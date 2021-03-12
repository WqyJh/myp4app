/* -*- P4_16 -*- */

/*
 * P4 Truncator
 *
 * This program implements a simple switch that truncate packet payload
 * to 10 bytes.
 */

#include <core.p4>
#include <v1model.p4>

/*
 * Define the headers the program will recognize
 */

/*
 * Standard Ethernet header 
 */
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

/*
 * All headers, used in the program needs to be assembled into a single struct.
 * We only need to declare the type, but there is no need to instantiate it,
 * because it is done "by the architecture", i.e. outside of P4 functions
 */
struct headers {
    ethernet_t   ethernet;
}

/*
 * All metadata, globally used in the program, also  needs to be assembled 
 * into a single struct. As in the case of the headers, we only need to 
 * declare the type, but there is no need to instantiate it,
 * because it is done "by the architecture", i.e. outside of P4 functions
 */
 
struct metadata {
    /* In our case it is empty */
}

/*
* Parser that accept all packets.
*/
parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {    
    state start {
        packet.extract(hdr.ethernet);
        transition accept;
    }
}

control MyVerifyChecksum(inout headers hdr,
                         inout metadata meta) {
    apply { }
}

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    action _truncate(bit<9> port) {
        truncate((bit<32>)64);
        standard_metadata.egress_spec = port;
    }

    table eth_truncate {
        key = {
            hdr.ethernet.dstAddr    : exact;
        }
        actions = {
            _truncate;
        }
        size = 128;
    }

    apply {
        eth_truncate.apply();
    }
}

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
    }
}

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
