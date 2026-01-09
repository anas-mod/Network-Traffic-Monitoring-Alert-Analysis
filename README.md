**Network Traffic Monitoring & Alert Analysis**
 
 *Project Objective*

The goal of this project is to analyze live network traffic within a virtualized Linux environment to distinguish between normal baseline traffic and abnormal patterns that may indicate security or performance issues. This project simulates a SOC/NOC workflow: establishing a "Known Good" state and investigating deviations.

 *Environment & Tools*

    OS: Arch Linux (Running dwm)

    Network: Bridged Adapter

    Tools: wireshark, tcpdump, nmap

 **Phase 1: Establishing the Baseline**

To identify anomalies, I first profiled "Normal" traffic to document standard protocol behavior:

    DNS (UDP/53): Profiled query/response latency and standard resolver behavior.

    HTTP/S (TCP/443): Documented the standard TCP 3-Way Handshake and TLS 1.3 session establishment.

 **Phase 2: Anomalous Traffic Analysis**

I utilized manual inspection techniques (Wireshark filters and tcpdump statistics) to identify simulated threats.

1. TCP SYN Flood (DoS)

    Technique: Identified a massive influx of SYN segments without corresponding ACK completions (Half-open connections).
    Filter: tcp.flags.syn == 1 and tcp.flags.ack == 0
    Impact: Increased half-open connections observed, which could contribute to resource exhaustion if sustained.

2. Reconnaissance (Port Scanning)

    Technique: Monitored nmap -sS (Stealth Scan) activity.
    Observation: High-frequency sequential connection attempts on ports 1–1024 from a single source IP.

 *Project Structure & Artifacts*

    /artifacts: Contains .pcap files for both baseline and attack scenarios.

    /docs: Detailed analysis reports on Abnormal TTL values (OS Fingerprinting) and Analysis of ICMP payload usage and its potential misuse for covert data transfer.
    
    /img: Screenshots of packet flows and terminal alerts.
