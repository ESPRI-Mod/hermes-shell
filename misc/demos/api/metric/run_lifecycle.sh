prodiguer help
# List set of groups (should be empty).
prodiguer metric-list

exit 0

# Add test groups.
prodiguer run-demo metric-lifecycle add
prodiguer run-demo metric-lifecycle add

# List set of groups (should be 2).
prodiguer run-demo metric-lifecycle list-group

# Fetch a group.
prodiguer run-demo metric-lifecycle fetch GROUP-ID

# Fetch group line count (should be 6).
prodiguer run-demo metric-lifecycle fetch-line-count GROUP-ID

# Delete group line.
prodiguer run-demo metric-lifecycle delete-line LINE-ID

# Fetch group line count (should be 5).
prodiguer run-demo metric-lifecycle fetch-line-count GROUP-ID

# Delete group lines.
prodiguer run-demo metric-lifecycle delete-line LINE-ID1-LINE-ID2-LINE-ID3

# Fetch group line count (should be 2).
prodiguer run-demo metric-lifecycle fetch-line-count GROUP-ID

# Delete group.
prodiguer run-demo metric-lifecycle delete-group GROUP-ID

# List set of groups (should be 1).
prodiguer run-demo metric-lifecycle list-group

# Add group from default json file.
prodiguer run-demo metric-lifecycle add-from-json

# List set of groups (should be 1).
prodiguer run-demo metric-lifecycle list-group

# Fetch group line count (should be 247).
prodiguer run-demo metric-lifecycle fetch-line-count hista2_k1

# Delete group.
prodiguer run-demo metric-lifecycle delete-group GROUP-ID

# List set of groups (should be 0).
prodiguer run-demo metric-lifecycle list-group

# Add group from default csv file.
prodiguer run-demo metric-lifecycle add-from-csv

# List set of groups (should be 1).
prodiguer run-demo metric-lifecycle list-group

# Fetch group line count (should be 247).
prodiguer run-demo metric-lifecycle fetch-line-count hista2_k1

# Delete group lines.
prodiguer run-demo metric-lifecycle fetch-line-count LINE-ID1-LINE-ID2-LINE-ID3

# Fetch group line count (should be 244).
prodiguer run-demo metric-lifecycle fetch-line-count hista2_k1

# Delete group.
prodiguer run-demo metric-lifecycle delete-group hista2_k1

# List set of groups (should be 0).
prodiguer run-demo metric-lifecycle list-group

# Add group from named csv file.
prodiguer run-demo metric-lifecycle add-from-csv /Users/macg/dev/prodiguer/repos/prodiguer-server/demos/metric/demo_files/HISTA2_K1.csv

# Add group from named json file.
prodiguer run-demo metric-lifecycle add-from-json /Users/macg/dev/prodiguer/repos/prodiguer-server/demos/metric/demo_files/HISTA2_K1.json
