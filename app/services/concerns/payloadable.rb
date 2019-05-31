# frozen_string_literal: true

module Payloadable
  def serialize_payload(record, serializer, serializer_options = {})
    ActiveModelSerializers::SerializableResource.new(record, serializer_options.merge(serializer: serializer, adapter: ActivityPub::Adapter)).as_json
  end

  def serialize_and_sign_payload(record, serializer, signer, **sign_options)
    if signing_enabled?
      ActivityPub::LinkedDataSignature.new(serialize_payload(record, serializer)).sign!(signer, sign_options)
    else
      serialize_payload(record, serializer)
    end
  end

  def signing_enabled?
    !Rails.configuration.x.whitelist_mode
  end
end
