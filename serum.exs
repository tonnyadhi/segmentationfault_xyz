%{
  site_name: "SegmentationFaultSite",
  site_description: "Scio Me Nihil Scire",
  date_format: "{WDfull}, {D} {Mshort} {YYYY}",
  base_url: "/",
  author: "Tonny Adhi Sabastian",
  author_email: "tonny@segmentationfault.xyz",
  plugins: [
    {Serum.Plugins.LiveReloader, only: :dev}
  ]
}
