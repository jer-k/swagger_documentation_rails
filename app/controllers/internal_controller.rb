class InternalController < ApplicationController

  def swagger
    @docs = {}
    build_docs(YAML::load(File.read(Rails.root.join('public/internal/docs', 'api.swagger.yaml'))))
    render json: @docs.to_json
  end

  private

  def build_docs(swagger_docs, parent_key = [])
    swagger_docs.each do |key, value|
      if key == '$include'
        value.each do |file|
          data = YAML::load(File.read(Rails.root.join('public/internal/docs', "#{file}")))
          unless parent_key.empty?
            hash_for_parent_key(parent_key).merge!(data)
          else
            @docs.merge!(data)
          end
        end
      elsif value.is_a?(Hash)
        unless parent_key.empty?
          hash_for_parent_key(parent_key)[key] = {}
          copied_parent_key = parent_key.dup
          build_docs(value, copied_parent_key << key)
        else
          @docs[key] = {}
          build_docs(value, [key])
        end
      else
        unless parent_key.empty?
          hash_for_parent_key(parent_key).merge!({key => value})
        else
          @docs.merge!({key => value})
        end
      end
    end
  end

  def hash_for_parent_key(parent_key)
    if parent_key.is_a?(Array)
      parent_key.inject(@docs, &:[])
    else
      @docs[parent_key]
    end
  end
end