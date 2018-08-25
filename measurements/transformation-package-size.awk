BEGIN {
  printf("language,platform,package_size_in_bytes\n")
}

{
  split($2, a, "/");
  printf("%s,%s,%d\n", a[4], a[3], $1);
}