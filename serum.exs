%{
  site_name: "Segmentation Fault",
  site_description: "Segfault is better than Kernel Panic",
  server_root: "https://segmentationfault.xyz",
  date_format: "{WDfull}, {D} {Mshort} {YYYY}",
  base_url: "/",
  author: "Tonny Adhi Sabastian",
  author_email: "tonny@segmentationfault.xyz",
  plugins: [
    {Serum.Plugins.LiveReloader, only: :dev},
    {Serum.Plugins.SitemapGenerator, args: [for: [:pages, :posts]], only: :prod}
  ],
  theme: Serum.Themes.Essence
}
