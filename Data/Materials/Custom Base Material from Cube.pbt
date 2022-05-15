Assets {
  Id: 6203078221193440846
  Name: "Custom Base Material from Cube"
  PlatformAssetType: 13
  SerializationVersion: 115
  VirtualFolderPath: "Placement System"
  CustomMaterialAsset {
    BaseMaterialId: 12222888365490483348
    ParameterOverrides {
      Overrides {
        Name: "u_tiles"
        Float: 100
      }
      Overrides {
        Name: "v_tiles"
        Float: 100
      }
    }
    Assets {
      Id: 12222888365490483348
      Name: "Grid Basic"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "grid_blue_001"
      }
    }
  }
}
