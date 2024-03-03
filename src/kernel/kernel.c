void clear_screen() {
  char *video_memory = (char *)0xb8000;
  for (int i = 0; i < 80 * 25; i++) {
    video_memory[i * 2] = ' ';
  }
}

int main(void) {
  clear_screen();
  char *video_memory = (char *)0xb8000;
  *video_memory = 'X';

  return 0;
}
