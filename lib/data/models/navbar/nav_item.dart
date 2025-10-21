class NavItem {
  final String icon;
  final String label;
  final String route;
  final bool isCenter;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isCenter = false,
  });
}
