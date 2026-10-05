_priv2pub_ed448() {
  local key="${(l:114::0:)1}"
  local der="3047020100300506032b6571043b0439${key}"

  echo -n "$der" | xxd -r -p \
    | openssl pkey -inform DER -pubout -outform DER 2>/dev/null \
    | tail -c 57 | xxd -p -c 57
}
