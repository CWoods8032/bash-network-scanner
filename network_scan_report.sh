#!/bin/bash

# Function
validate_input() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <target_ip_or_hostname>" >&2
    exit 1
  fi
}

# Header
write_header() {
  local target=$1
  echo "Network Security Scan Report"
  echo "=============================="
  echo ""
  echo "Target IP/Hostname: $target"
  echo ""
}

# Ports Section
write_ports_section() {
  local target=$1
  echo "Open Ports and Detected Services:"
  echo "---------------------------------"

  # Run nmap scan
  nmap -sV "$target" | grep "open"
  echo ""
}

# Vulnerabilities Section
write_vulns_section() {
  echo "Potential Vulnerabilities Identified:"
  echo "-------------------------------------"

  # NSE Results
  echo "--- NSE Script Output ---"
  echo "$SCAN_RESULTS" | grep -A 5 "VULNERABLE"

  echo ""
  echo "--- Analyzing Service Versions ---"
  echo "$SCAN_RESULTS" | while read -r line; do
    case "$line" in
      *"vsftpd 2.3.4"*)
        echo "[!!] VULNERABILITY DETECTED: vsftpd 2.3.4 has a known backdoor (CVE-2011-2523)."
        ;;
      *"Apache httpd 2.4.49"*)
        echo "[!!] VULNERABILITY DETECTED: Apache 2.4.49 is vulnerable to path traversal (CVE-2021-41773)."
        ;;
      *"OpenSSH 7.2p2"*)
        echo "[!!] VULNERABILITY DETECTED: OpenSSH 7.2p2 has known vulnerabilities (CVE-2016-0777)."
        ;;
      *"Exim smtpd 4.87"*)
        echo "[!!] VULNERABILITY DETECTED: Exim 4.87 is vulnerable to remote code execution (CVE-2016-1531)."
        ;;
    esac
  done

  echo ""
}

# Recommendations Section
write_recs_section() {
  echo "Recommendations for Remediation:"
  echo "-------------------------------"
  echo "1. Update all software to the latest versions."
  echo "2. Change all default credentials immediately."
  echo "3. Implement a properly configured firewall."
  echo "4. Disable unnecessary services."
  echo ""
}

# Footer
write_footer() {
  echo "End of Report"
  echo "Generated on: $(date)"
}

#Main Function
main() {
  validate_input "$@"

  local target="$1"
  local REPORT_FILE="report.txt"

  echo "[*] Running enhanced Nmap scan with vulnerabilty scripts..."
  SCAN_RESULTS=$(nmap -sV --script vuln "$target")

  # Overwrite
  write_header "$target" > "$REPORT_FILE"
  write_ports_section "$target" >> "$REPORT_FILE"
  write_vulns_section >> "$REPORT_FILE"
  write_recs_section >> "$REPORT_FILE"
  write_footer >> "$REPORT_FILE"

  echo "[*] Scan complete. Report saved to $REPORT_FILE"
}

main "$@"
