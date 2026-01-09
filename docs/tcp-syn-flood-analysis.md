# Technical Analysis: TCP SYN Flood (Denial of Service)


**Target System:** Arch Linux (VirtualBox)
**Incident Type:** Resource Exhaustion / Protocol Abuse

---

## 1. Incident Overview
I simulated SYN Flood-trffic to study how the Linux tcp stack handles incomplete connection requests. The attack targets the **TCP Three-Way Handshake** to exhaust the system's "Backlog Queue."

## 2. The Mechanism (Hardware/Software Interaction)
When a `SYN` packet arrives at the Network Interface Card (NIC):
1. The **Kernel** receives an interrupt and allocates state information associated with **Transmission Control Block (TCB)**.
2. The system enters the `SYN_RECV` state.
3. Because the attacker never sends the final `ACK`, the CPU must keep that memory "reserved" until a timeout occurs.
4. **Result:** New, legitimate users cannot connect because the "Backlog Queue" is full of half-open connections.

## 3. Evidence Collection
Using `tcpdump`, I captured the following patterns:
* **Packet Volume:** An increase from 5-10 pps to over 500 pps.
* **Flag Analysis:** 99% of incoming TCP traffic consisted of the `SYN` flag only.



## 4. Manual Detection (Wireshark)
I applied the following display filter to isolate the attack:
`tcp.flags.syn == 1 and tcp.flags.ack == 0`

This revealed a high volume of SYN-only packets without corresponding ACK response, confirming that no handshakes were being completed.

The following mitigations are listed for defensive understanding and were not applied on the test system.

## 5. Mitigation & Defensive Strategy
In a production SOC environment, I would recommend:
* **Enabling SYN Cookies:** `sysctl -w net.ipv4.tcp_syncookies=1` (This allows the kernel to handle the flood without exhausting the backlog queue).
* **Rate Limiting:** Implementing `iptables` rules to drop connections from IPs exceeding a specific request threshold.
