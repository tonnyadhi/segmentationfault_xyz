%{
  site_name: "Segmentation Fault Site",
  site_description: "Segfault is better than Kernel Panic",
  date_format: "{WDfull}, {D} {Mshort} {YYYY}",
  base_url: "/",
  author: "Tonny Adhi Sabastian",
  author_email: "tonny@segmentationfault.xyz",
  plugins: [
    {Serum.Plugins.LiveReloader, only: :dev}
  ],
  theme: Serum.Themes.Essence
}
