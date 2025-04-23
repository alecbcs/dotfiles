# Function: demo
# Author: Alec Scott
# Description: Toggles between a demo-friendly prompt and the original prompt
demo() {
  if [[ -z "$ORIGINAL_PROMPT" ]]; then
    # Save the original prompt
    export ORIGINAL_PROMPT="$PROMPT"

    # Set the custom prompt
    prompt_prefix='%F{blue}alec@laptop%F{reset_color}'
    export PROMPT='${prompt_prefix}:$(prompt_pwd) $(git_branch)'$'\n''> '

    echo "Demo mode activated."
  else
    # Restore the original prompt
    export PROMPT="$ORIGINAL_PROMPT"
    unset ORIGINAL_PROMPT
    unset prompt_prefix

    echo "Demo mode deactivated. Original prompt restored."
  fi
}
