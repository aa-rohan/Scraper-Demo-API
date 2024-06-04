module Searchable
  extend ActiveSupport::Concern
  included do
    scope :search,
          lambda { |keys, value|
            return unless value.present?

            where(
              keys
                .map { |c| " CAST(#{c} as TEXT) ILIKE :search" }
                .join(' OR '),
              search: "%#{value&.strip}%"
            )
          }
  end
end
