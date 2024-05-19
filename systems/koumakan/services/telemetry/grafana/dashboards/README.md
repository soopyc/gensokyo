# Grafana Dashboards

Reproducible definitions of grafana dashboards. Most of these are obtained are obtained from Grafana's site directly.
Please see our `utils/justfile` for more details.

## Obtaining a new dashboard
Run the following just recipe.

```console
# just utils add-grafana-dashboard <id> <name> [title]
#                     dashboard id  ^     ^     ^ (visible) dashboard title
#                            dashboard json name (invisible)

$ just utils add-grafana-dashboard 1860 node "Node Metrics"
xh https://grafana.com/api/dashboards/1860 | jq '.json | .uid="node" | .title="Node Metrics"' -c > ../systems/koumakan/services/telemetry/grafana/dashboards/node.json
```
