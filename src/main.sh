# ── Main Routing ──────────────────────────────────────────────────────────────

case "${1:-}" in
  init) shift; cmd_init "$@" ;;
  update) shift; cmd_update "$@" ;;
  doctor) cmd_doctor ;;
  completion) shift; cmd_completion "$@" ;;
  --version|-v) echo "izicontext $VERSION" ;;
  --help|-h|"") cmd_help ;;
  *) print_red "Unknown command: $1. Run 'izicontext --help' for usage."; exit 1 ;;
esac
