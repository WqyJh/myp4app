# Implementing a P4 Truncator

Run this app.

```bash
p4app run examples/truncate.app
```

Start capture on h2 from another shell.

```bash
p4app exec m h2 tcpdump
```

Send packet from h1 whose length was large than 100 bytes.

```
mininet> h1 python calc.py 
###[ Ethernet ]###
  dst       = 00:04:00:00:00:01
  src       = 00:00:00:00:00:00
  type      = 0x1234
###[ Raw ]###
     load      = 'puppy runs odd foolishly. girl drives dirty occasionally. puppy hits clueless merrily. monkey drives odd crazily. '
.
Sent 1 packets.
```

See captured packet and find that the packet was truncated to 64 bytes.

```bash
$ p4app exec m h2 tcpdump
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on h2-eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
15:47:07.217724 00:00:00:00:00:00 (oui Ethernet) > 00:04:00:00:00:01 (oui Unknown), ethertype Unknown (0x1234), length 64: 
        0x0000:  7075 7070 7920 7275 6e73 206f 6464 2066  puppy.runs.odd.f
        0x0010:  6f6f 6c69 7368 6c79 2e20 6769 726c 2064  oolishly..girl.d
        0x0020:  7269 7665 7320 6469 7274 7920 6f63 6361  rives.dirty.occa
        0x0030:  7369                                     si
```
