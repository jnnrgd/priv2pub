_priv2pub_p256() {
  local key="${(l:64::0:)1}"
  local compressed="$2"
  local der="30310201010420${key}a00a06082a8648ce3d030107"

  if [[ "$compressed" == true ]]; then
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form compressed -outform DER 2>/dev/null \
      | tail -c 33 | xxd -p -c 33
  else
    echo -n "$der" | xxd -r -p \
      | openssl ec -inform DER -pubout -conv_form uncompressed -outform DER 2>/dev/null \
      | tail -c 65 | xxd -p -c 65
  fi
}
