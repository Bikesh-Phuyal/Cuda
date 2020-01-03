#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
This program shows a poor way to implement a password cracker in CUDA C. It's poor because it accomplishes this with a single thread, which definitely is not good given the scale to which CUDA programs have parallelism.
The intentions of this program are:
1) Demonstrate the use of __device__ and __global__ functions
2) Enable a simulation of password cracking in the absence of library
with equivalent functionality to libcrypt. The password to be found
is hardcoded into a function called is_a_match.
Compile and run with:
nvcc -o passwordcrack_cuda passwordcrack_cuda.cu
./passwordcrack_cuda
Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/
/****************************************************************************
This function returns 1 if the attempt at cracking the password is
identical to the plain text password string stored in the program.
Otherwise,it returns 0.
*****************************************************************************/
__device__ int is_a_match(char *attempt) {
char plain_password1[] = "BP9843";
char plain_password2[] = "RP6870";
char plain_password3[] = "AP6498";
char plain_password4[] = "IP1354";
char *m = attempt;
char *s = attempt;
char *c = attempt;
char *d = attempt;
char *p1 = plain_password1;
char *p2 = plain_password2;
char *p3 = plain_password3;
char *p4 = plain_password4;
while(*m == *p1) {
if(*m == '\0')
{
printf("Password: %s\n",plain_password1);
break;
}
m++;
p1++;
}while(*s == *p2) {
if(*s == '\0')
{
printf("Password: %s\n",plain_password2);
break;
}
s++;
p2++;
}
while(*c == *p3) {
if(*c == '\0')
{
printf("Password: %s\n",plain_password3);
break;
}
c++;
p3++;
}
while(*d == *p4) {
if(*d == '\0')
{
printf("Password: %s\n",plain_password4);
return 1;
}
d++;
p4++;
}
return 0;
}
__global__ void kernel() {
char i1,i2,i3,i4; //variables
char password[7];
password[6] = '\0';
//block id thread id initilized
int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstMatch = i;
char secondMatch = j;
password[0] = firstMatch;
password[1] = secondMatch;
for(i1='0'; i1<='9'; i1++){
for(i2='0'; i2<='9'; i2++){
for(i3='0'; i3<='9'; i3++){
for(i4='0'; i4<='9'; i4++){
password[2] = i1;
password[3] = i2;
password[4] = i3;
password[5] = i4;
if(is_a_match(password)) {
}
else {
//printf("tried: %s\n", password);
}}
}
}
}
}
//time difference
int time_difference(struct timespec *start,
struct timespec *finish,
long long int *difference) {
long long int ds = finish->tv_sec - start->tv_sec;
long long int dn = finish->tv_nsec - start->tv_nsec;
if(dn < 0 ) {
ds--;
dn += 1000000000;
}
*difference = ds * 1000000000 + dn;
return !(*difference > 0);
}
int main() {
struct timespec start, finish;
long long int time_elapsed;
clock_gettime(CLOCK_MONOTONIC, &start);
// Kernel function to evaluate the block and thread to be used
 kernel <<<26,26>>>();
cudaThreadSynchronize();
clock_gettime(CLOCK_MONOTONIC, &finish);
time_difference(&start, &finish, &time_elapsed);
printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9));
return 0;
}
