
#include <stdio.h>
#include <string.h>

int main(){
    char line[100],a[50],b[50],c[50],dest[50];

    while(fgets(line,sizeof(line),stdin)){
        if(line[0]=='L' && strchr(line,':')){
            printf("%s",line);
        }
        else if(sscanf(line,"if %49s > %49s goto %49s",a,b,dest)==3){
            printf("CMP %s, %s\n",a,b);
            printf("JG %s\n",dest);
        }
        else if(sscanf(line,"goto %49s",dest)==1){
            printf("JMP %s\n",dest);
        }
        else if(sscanf(line,"%49s = %49s + %49s",a,b,c)==3){
            printf("MOV R0, %s\n",b);
            printf("ADD R0, %s\n",c);
            printf("MOV %s, R0\n",a);
        }
        else if(sscanf(line,"%49s = %49s * %49s",a,b,c)==3){
            printf("MOV R0, %s\n",b);
            printf("MUL R0, %s\n",c);
            printf("MOV %s, R0\n",a);
        }
        else if(sscanf(line,"%49s = %49s - %49s",a,b,c)==3){
            printf("MOV R0, %s\n",b);
            printf("SUB R0, %s\n",c);
            printf("MOV %s, R0\n",a);
        }
        else if(sscanf(line,"%49s = %49s / %49s",a,b,c)==3){
            printf("MOV R0, %s\n",b);
            printf("DIV R0, %s\n",c);
            printf("MOV %s, R0\n",a);
        }
        else if(sscanf(line,"%49s = %49s",a,b)==2){
            printf("MOV %s, %s\n",a,b);
        }
        else{
            printf("%s",line);
        }
    }

    return 0;
}
