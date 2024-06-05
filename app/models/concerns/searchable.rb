module Searchable
  extend ActiveSupport::Concern
  class_methods do
    def searchable_fields(*fields)
      @searchable_fields = fields.map(&:to_s)
    end

    def search(value)
      return unless value.present?

      where(
        @searchable_fields
          .map { |c| " CAST(#{c} as TEXT) ILIKE :search" }
          .join(' OR '),
        search: "%#{value&.strip}%"
      )
    end
  end
end
