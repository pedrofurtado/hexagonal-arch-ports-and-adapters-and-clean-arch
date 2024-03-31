require 'terminal-table'
require 'xmlsimple'

module DomainCore
  module Presenters
    class Product
      def from(list_product_output_dto)
        @list_product_output_dto = list_product_output_dto
        self
      end

      def convert_to_json
        list_product_output_dto.products.map do |product_record|
          {
            Id: product_record.id,
            Name: product_record.name,
            Situation: product_record.status
          }
        end
      end

      def convert_to_xml
        payload_as_hash = list_product_output_dto.products.map do |product_record|
          {
            Codigo: product_record.id,
            Nome: product_record.name,
            Situacao: product_record.status
          }
        end

        XmlSimple.xml_out(payload_as_hash, {:keeproot => true, :noescape => true})
      end

      def convert_to_ascii_terminal_table
        rows = list_product_output_dto.products.map do |product_record|
          [product_record.id, product_record.name, product_record.status]
        end

        ::Terminal::Table.new :title => "Products", :headings => ['ID', 'Full name', 'Status'], :rows => rows
      end

      private

      attr_reader :list_product_output_dto
    end
  end
end
