module Ethereum

  class Initializer
    attr_accessor :contracts, :file, :client

    def initialize(file, client = Ethereum::IpcClient.new)
      @file = File.read(file)
      @client = client
      sol_output = @client.eth_compile_solidity(@file)
      contracts = sol_output["result"].keys
      @contracts = []
      contracts.each do |contract|
        abi = sol_output["result"][contract]["info"]["abiDefinition"]
        name = contract.sub('<stdin>:', '')
        code = sol_output["result"][contract]["code"]
        @contracts << Ethereum::Contract.new(name, code, abi)
      end
    end

    def build_all
      @contracts.each do |contract|
        contract.build(@client)
      end
    end

  end
end
