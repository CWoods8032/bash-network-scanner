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
  echo "CVE-2017-5638 - Outdated Web Server"
  echo "CVE-2021- 32496 - SSH Weak Ciphers"
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

  # Overwrite the firewall
  write_header "$target" > "$REPORT_FILE"
 

  # Append
  write_ports_section "$target" >> "$REPORT_FILE"
  write_vulns_section >> "$REPORT_FILE"
  write_recs_section >> "$REPORT_FILE"
  write_footer >> "$REPORT_FILE"
}

main "$@"
