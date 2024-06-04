module Serializable
  extend ActiveSupport::Concern

  class_methods do
    def serialize(*attributes)
      define_method :serialized_attributes do
        attributes.each_with_object({}) do |attr, hash|
          hash[attr] = send(attr) if respond_to?(attr)
        end
      end
    end
  end
end
