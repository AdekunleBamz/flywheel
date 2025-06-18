module "flywheel_publisher_registry" {
  # source = "git::https://github.cbhq.net/smart-contracts/modules.git//modules/evmsmartcontract?ref=v0.1.3"
  source = "git::https://github.cbhq.net/terraform/scm-modules.git//modules/evmsmartcontract"

  keychain_signer = scm_keychain_key.flywheel-protocol-base-sepolia-base-sepolia-deploy-key

  artifact_path = "../../out/FlywheelPublisherRegistry.sol/FlywheelPublisherRegistry.json"
  constructor_args = {}

  inventory_metadata = {
    # language
    language = "solidity"
    project_name = local.project_name
    contract_name = "FlywheelPublisherRegistry"
    # is_proxy = true for UUPS upgradeable contracts
    is_proxy = true
    # implementation_addresses = []
    privileged_role_addresses = {
      "owner" = scm_keychain_key.flywheel-protocol-base-sepolia-base-sepolia-deploy-key.default_address
    }
    # source_code_url = "https://github.cbhq.net/smart-contracts/contract-template/blob/master/src/FlywheelPublisherRegistry.sol"
    # source_code_data = "" // Optional
  }

  etherscan_verification = {
    enabled = true # Enable this to verify contract on Etherscan
    contract_name = "src/FlywheelPublisherRegistry.sol:FlywheelPublisherRegistry"
    build_info_path = "../../out/build-info/1bd655e5e5e3281b4dff91c8616519ba.json"
  }

}

# Initialize the upgradeable contract after deployment
resource "scm_evm_transaction" "initialize_flywheel_publisher_registry" {
  kms = {
    keychain_signer_id = scm_keychain_key.flywheel-protocol-base-sepolia-base-sepolia-deploy-key.id
  }

  address = module.flywheel_publisher_registry.contract_address
  abi = module.flywheel_publisher_registry.contract_abi
  function_name = "initialize"
  args = {
    "_owner" = scm_keychain_key.flywheel-protocol-base-sepolia-base-sepolia-deploy-key.default_address
    "_signerAddress" = "0x7116F87D6ff2ECa5e3b2D5C5224fc457978194B2"
  }
}

output "flywheel_publisher_registry_contract_address" {
  value = module.flywheel_publisher_registry.contract_address
} 