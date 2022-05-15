Assets {
  Id: 4968034480831954642
  Name: "Preview Hologram"
  PlatformAssetType: 13
  SerializationVersion: 115
  VirtualFolderPath: "Placement System"
  CustomMaterialAsset {
    BaseMaterialId: 9863993854945601847
    ParameterOverrides {
      Overrides {
        Name: "emissive_boost"
        Float: 40
      }
      Overrides {
        Name: "scanlines"
        Float: 10
      }
      Overrides {
        Name: "scanline scale"
        Float: 10
      }
      Overrides {
        Name: "scanline speed"
        Float: 0
      }
      Overrides {
        Name: "color"
        Color {
          R: 0.0286430363
          G: 0.802000046
          A: 1
        }
      }
    }
    Assets {
      Id: 9863993854945601847
      Name: "Basic Hologram"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "fxmi_basic_hologram"
      }
    }
  }
}
