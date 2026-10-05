_priv2pub_p384() {
  local key="${(l:96::0:)1}"
  local compressed="$2"
  local der="303e0201010430${key}a00706052b81040022"

  if [[ "$compressed" == true ]]; then
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form compressed -outform DER 2>/dev/null \
      | tail -c 49 | xxd -p -c 49
  else
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form uncompressed -outform DER 2>/dev/null \
      | tail -c 97 | xxd -p -c 97
  fi
}
