#!/bin/bash

pkglist=(
  bradlc.vscode-tailwindcss
  BriteSnow.vscode-toggle-quotes
  Catppuccin.catppuccin-vsc
  CoenraadS.disableligatures
  csstools.postcss
  dbaeumer.vscode-eslint
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  PKief.material-icon-theme
  shd101wyy.markdown-preview-enhanced
  unifiedjs.vscode-mdx
  VisualStudioExptTeam.intellicode-api-usage-examples
  VisualStudioExptTeam.vscodeintellicode
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done
