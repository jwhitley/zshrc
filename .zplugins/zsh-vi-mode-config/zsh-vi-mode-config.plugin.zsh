# This plugin must be loaded before zsh-vi-mode to correctly configure it

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}
