_priv2pub_p521() {
  local key="${(l:132::0:)1}"
  local compressed="$2"
  local der="30500201010442${key}a00706052b81040023"

  if [[ "$compressed" == true ]]; then
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form compressed -outform DER 2>/dev/null \
      | tail -c 67 | xxd -p -c 67
  else
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form uncompressed -outform DER 2>/dev/null \
      | tail -c 133 | xxd -p -c 133
  fi
}
