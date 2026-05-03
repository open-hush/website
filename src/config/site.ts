export const SITE = {
  name: "OpenHush",
  tagline: "Audio adventures for kids — fully open-source.",
  description:
    "OpenHush is an open-source audio platform for families. Hush is the device, Whispers are the cards. Privacy-first, hackable, made with care.",
  url: "https://open-hush.com",
  github: "https://github.com/OpenHush",
  repo: "https://github.com/OpenHush/website",
  // TODO: confirm dashboard repo URL once published.
  dashboardRepo: "https://github.com/OpenHush/dashboard",
  twitter: "",
  discord: "",
  license: "MIT",
  email: "hello@open-hush.com",
} as const;

export const NAV_LINKS = [
  { label: "What is it", href: "/#what-is" },
  { label: "Hush", href: "/#hush" },
  { label: "Whispers", href: "/#whispers" },
  { label: "Families", href: "/#families" },
  { label: "Developers", href: "/developers" },
] as const;
