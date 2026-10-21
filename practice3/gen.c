#include <stdio.h>
#include <string.h>

int main(){
    char line[100],a[50],b[50],c[50],op[10],dest[50];
    while (fgets(line,sizeof(line),stdin)){
        if (line[0]=='L'){
            printf("%s\n",line);
        }
        else if (sscanf(line,"if %s < %s goto %s",a,b,dest)==3){
            printf("CMP %s,%s\n",a,b);
            printf("JL %s",dest);
        }
        else if (sscanf(line,"goto %s",dest)==1){
            printf("JMP %s\n",dest);
        }
        else if (sscanf(line,"%s = %s %s %s\n",a,b,op,c)==4){
            printf("MOV R0,%s\n",b);
            if (strcmp(op,"+")==0) printf("ADD R0,%s\n",c);
            else if (strcmp(op,"-")==0) printf("SUB R0,%s\n",c);
            else if (strcmp(op,"*")==0) printf("MUL R0,%s\n",c);
            else if (strcmp(op,"/")==0) printf("DIV R0,%s\n",c);
            printf("MOV %s, R0\n",a);
        }
        else if (sscanf(line,"%s = %s\n",a,b)==2){
            printf("MOV %s, %s",a,b);
        }
    }
    return 0;
}