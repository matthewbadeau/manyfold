class Slicer < ApplicationRecord
  validates :name,
    presence: true
  validates :uri,
    presence: true,
    format: {with: /\A[[:alnum:]]*:\/\//} # matches any URI with `applicationname://`
end
