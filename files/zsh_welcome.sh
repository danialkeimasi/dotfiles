autopac_check() {
  if [ -f /var/log/autopac_done ]; then
    echo "  Pacman updates have been downloaded."
    echo
    journalctl --since="-24h" -u autopac | grep -E ' Starting | Packages | Download Size:| Finished ' --color=never | python -c 'import fileinput, textwrap, re; print("".join([re.sub(r"^(.*? Packages \(.*?\))(.*)", r"\1", line ) + "    " + "\n    ".join(textwrap.wrap(line.split(") ")[1], width=90, break_on_hyphens=False)) + "\n" if " Packages " in line else line for line in fileinput.input()]), end="")' | sed 's/^/  /'
    echo
    echo "  View logs:"
    echo
    echo "       $ journalctl -u autopac --since='-24h'"
    echo
    echo "  Install updates manually:"
    echo
    echo "       $ autopac_sync"
    echo
  fi
}

autopac_sync() {
  sudo pacman -Syu && sudo rm /var/log/autopac_done
}

autopac_check
