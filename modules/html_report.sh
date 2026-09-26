#! /bin/bash
generate_html_report(){
    {
    echo "<html><head><title>Security Scan Report</title></head><body>"
    echo "<h1>Security Assessment Report</h1>"
    echo "<h2>Summary</h2><pre>$(cat "$summary_file")</pre>"
    echo "<h2>Scan Details</h2><pre>$(cat "$scan_file")</pre>"
    echo "<h2>Findings</h2><pre>$(cat "$finding_file")</pre>"
    echo "</body></html>"
    } > "./report/report.html"
}
