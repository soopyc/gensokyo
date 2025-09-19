{
  programs.lazygit = {
    enable = true;
    settings = {
      # we use ssh keys as auth, and this is hyper annoying for when we want to do literally anything longer than 2 minutes.
      # we think the concept of autofetching is kind of stupid anyways. i will fetch when i want to.
      git.autoFetch = false;
    };
  };
}
