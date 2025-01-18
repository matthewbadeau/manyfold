require "string/similarity"

class UnsupportedFormatError < StandardError
end

class NonManifoldError < StandardError
end

class Analysis::FileConversionJob < ApplicationJob
  queue_as :performance
  sidekiq_options retry: false

  def perform(file_id, output_format)
    # Get model
    file = ModelFile.find(file_id)
    # Can we output this format?
    raise UnsupportedFormatError unless SupportedMimeTypes.can_export?(output_format) || !file.loadable?
    exporter = nil
    extension = nil
    status[:step] = "jobs.analysis.file_conversion.loading_mesh" # i18n-tasks-use t('jobs.analysis.file_conversion.loading_mesh')
    case output_format
    when :threemf
      raise NonManifoldError.new if !file.mesh.manifold?
      extension = "3mf"
      exporter = Mittsu::ThreeMFExporter.new
    end
    if exporter
      status[:step] = "jobs.analysis.file_conversion.exporting" # i18n-tasks-use t('jobs.analysis.file_conversion.exporting')
      new_file = ModelFile.new(
        model: file.model,
        filename: file.filename.gsub(".#{file.extension}", ".#{extension}")
      )
      dedup = 0
      while new_file.exists_on_storage?
        dedup += 1
        new_file.filename = file.filename.gsub(".#{file.extension}", "-#{dedup}.#{extension}")
      end
      # Save the actual file in new format
      Tempfile.create do |outfile|
        exporter.export(file.mesh, outfile.path)
        new_file.attachment = outfile
      end
      # Store record in database
      new_file.save
      # Queue up file scan
      Analysis::AnalyseModelFileJob.perform_later(new_file.id)
    end
  rescue NonManifoldError
    # Log non-manifold error as a problem, and absorb error so we don't retry
    Problem.create_or_clear(
      file,
      :non_manifold,
      true
    )
  ensure
    if file
      # Mark inefficient problem resolution as no longer in progress, if it's set
      file.problems.where(category: :inefficient, in_progress: true).find_each do |it|
        it.update(in_progress: false)
      end
    end
  end
end
