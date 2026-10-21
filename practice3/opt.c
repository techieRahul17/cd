#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

int main() {
    char lines[200][200], lhs[50], a[50], op[10], b[50];
    int move[200] = {0}, n = 0, start = -1, back = -1;
    int loop, changed, id = 0;

    while (n < 200 && fgets(lines[n], 200, stdin))
        n++;

    for (int i = 0; i < n; i++) {
        if (sscanf(lines[i], "L%d:", &id) == 1) {
            start = i;
            break;
        }
    }

    if (start == -1) {
        for (int i = 0; i < n; i++) printf("%s", lines[i]);
        return 0;
    }

    for (int i = start + 1; i < n; i++) {
        int dest;
        if (sscanf(lines[i], "goto L%d", &dest) == 1 && dest == id) {
            back = i;
            break;
        }
    }

    if (back == -1) {
        for (int i = 0; i < n; i++) printf("%s", lines[i]);
        return 0;
    }

    do {
        changed = 0;

        for (int i = start + 1; i < back; i++) {
            if (move[i]) continue;

            if (sscanf(lines[i], "%s = %s %s %s", lhs, a, op, b) != 4)
                continue;

            if (lhs[0] != 't' || !isdigit(lhs[1]))
                continue;

            int valid = 1;
            char *p[2] = {a, b};

            for (int k = 0; k < 2; k++) {
                char *end;
                strtol(p[k], &end, 10);

                if (*p[k] != '\0' && *end == '\0')
                    continue;

                int assigned = 0, moved = 0;

                for (int j = start + 1; j < back; j++) {
                    char name[50];

                    if (sscanf(lines[j], "%s =", name) == 1 &&
                        strcmp(name, p[k]) == 0) {
                        assigned = 1;
                        if (move[j]) moved = 1;
                    }
                }

                if (assigned && !moved)
                    valid = 0;
            }

            if (valid) {
                move[i] = 1;
                changed = 1;
            }
        }
    } while (changed);

    for (int i = 0; i < n; i++) {
        if (i == start)
            for (int j = start + 1; j < back; j++)
                if (move[j]) printf("%s", lines[j]);

        if (!move[i]) printf("%s", lines[i]);
    }

    return 0;
}