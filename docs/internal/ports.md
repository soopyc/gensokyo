# Ports

This section mainly focuses on our existing port definition stuff.
We try to not use ports as much and to use unix sockets, but sometimes it's just not possible.

Note: most of this document focuses on koumakan.

## Defined port ranges

- `20xxx`: Prometheus/Metrics
  - `2009x`: core metrics, node metrics
  - `201xx`: service metrics

- `3xxxx`: Service ports
  - `35xxx`: exposed docker container ports
