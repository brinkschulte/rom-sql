require 'spec_helper'

RSpec.describe ROM::SQL::Association::OneToOne do
  subject(:assoc) {
    ROM::SQL::Association::OneToOne.new(:users, :accounts)
  }

  include_context 'users and accounts'

  before do
    configuration.relation(:accounts) do
      schema do
        attribute :id, ROM::SQL::Types::Serial
        attribute :user_id, ROM::SQL::Types::ForeignKey(:users)
        attribute :number, ROM::SQL::Types::String
        attribute :balance, ROM::SQL::Types::Decimal
      end
    end
  end

  describe '#call' do
    it 'prepares joined relations' do
      relation = assoc.call(container.relations)

      expect(relation.attributes).to eql(%i[id user_id number balance])
      expect(relation.to_a).to eql([id: 1, user_id: 1, number: '42', balance: 10_000.to_d])
    end
  end

  describe '#combine_keys' do
    it 'returns key-map used for in-memory tuple-combining' do
      expect(assoc.combine_keys(container.relations)).to eql(id: :user_id)
    end
  end
end
