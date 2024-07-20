# impure alert
{
  name,
  content,
}:
builtins.toFile name (builtins.toJSON content)
