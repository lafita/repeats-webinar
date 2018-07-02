# This script converts a multiple sequence alignment into a matrix
# of pairwise sequence identities.
#
# Aleix Lafita - June 2018


# Input alignment and output identity matrix files
alignment_file = "PF06758_A0A87WZJ2.sto"
matrix_file = "PF06758_A0A87WZJ2_matrix.tsv"

with open(alignment_file, 'r') as input, open(matrix_file, 'w') as output:

    # Load the alignment into a dictionary
    alignment = {}
    domains = []

    # Read every line in the alignment file
    for line in input:

        # Check for comment lines or separators (Stockholm format)
        if not line.startswith("#") and not line.startswith("//"):

            row = line.split()
            domain_id = row[0]
            domains.append(domain_id)

            if domain_id not in alignment.keys():
                alignment[domain_id] = {}

            alignment[domain_id] = row[1].strip("\n")

    # Compute the sequence identity between all domain pairs
    output.write("domain1\tdomain2\tpid\n")

    # Double for loop for each domain pair
    for i in range(0, len(domains)):
        domain1 = domains[i]

        for j in range(i + 1, len(domains)):
            domain2 = domains[j]

            length = 0
            identicals = 0

            # Just a check that the alignment is correct and residues are in position
            assert len(alignment[domain1]) == len(alignment[domain2])

            # Compare each position in the alignment
            for x in range(0, len(alignment[domain1])):

                # Check for gaps and aligned residues only
                if (alignment[domain1][x] != '.'
                    and alignment[domain2][x] != '.'
                    and alignment[domain1][x] != '-'
                    and alignment[domain2][x] != '-'
                    and alignment[domain1][x].isupper()
                    and alignment[domain2][x].isupper()):

                    length += 1
                    if (alignment[domain1][x] == alignment[domain2][x]):
                        identicals += 1

            # Compute the percentage of identity
            pid = 1.0 * identicals / length

            # Write the results into a tab separated format
            output.write("{}\t{}\t{}\n".format(domain1, domain2, pid))

