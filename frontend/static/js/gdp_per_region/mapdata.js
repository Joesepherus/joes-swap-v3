var simplemaps_countrymap_mapdata = {
  main_settings: {
    //General settings
    width: "responsive", //'700' or 'responsive'
    background_color: "#FFFFFF",
    background_transparent: "yes",
    border_color: "#ffffff",

    //State defaults
    state_description: "State description",
    state_color: "#88A4BC",
    state_hover_color: "#3B729F",
    state_url: "",
    border_size: 1.5,
    all_states_inactive: "no",
    all_states_zoomable: "yes",

    //Label defaults
    label_color: "#ffffff",
    label_hover_color: "#ffffff",
    label_size: 16,
    label_font: "Arial",
    label_display: "auto",
    label_scale: "yes",
    hide_labels: "no",
    hide_eastern_labels: "no",

    //Zoom settings
    zoom: "yes",
    manual_zoom: "yes",
    back_image: "no",
    initial_back: "no",
    initial_zoom: "-1",
    initial_zoom_solo: "no",
    region_opacity: 1,
    region_hover_opacity: 0.6,
    zoom_out_incrementally: "yes",
    zoom_percentage: 0.99,
    zoom_time: 0.5,

    //Popup settings
    popup_color: "white",
    popup_opacity: 0.9,
    popup_shadow: 1,
    popup_corners: 5,
    popup_font: "12px/1.5 Verdana, Arial, Helvetica, sans-serif",
    popup_nocss: "no",

    //Advanced settings
    div: "map",
    auto_load: "yes",
    url_new_tab: "no",
    images_directory: "default",
    fade_time: 0.1,
    link_text: "View Website",
    popups: "detect",
    state_image_url: "",
    state_image_position: "",
    location_image_url: "",
  },
  state_specific: {
    PH00: {
      name: "National Capital Region",
      description: "₱7,572.34 B (31.14%)",
      color: "rgb(0, 40, 120)",  // Darkest blue for highest percentage
    },
    PH01: {
      name: "Ilocos",
      description: "₱814.28 B (3.35%)",
      color: "rgb(130, 170, 220)",
    },
    PH02: {
      name: "Cagayan Valley",
      description: "₱510.83 B (2.10%)",
      color: "rgb(160, 200, 235)",
    },
    PH03: {
      name: "Central Luzon",
      description: "₱2,650.68 B (10.89%)",
      color: "rgb(40, 80, 160)",  // Darker blue for high percentage
    },
    PH05: {
      name: "Bicol",
      description: "₱701.72 B (2.88%)",
      color: "rgb(140, 180, 225)",
    },
    PH06: {
      name: "Western Visayas",
      description: "₱1,244.68 B (5.11%)",
      color: "rgb(100, 140, 200)",
    },
    PH07: {
      name: "Central Visayas",
      description: "₱1,579.06 B (6.49%)",
      color: "rgb(80, 120, 180)",
    },
    PH08: {
      name: "Eastern Visayas",
      description: "₱568.71 B (2.34%)",
      color: "rgb(150, 190, 230)",
    },
    PH09: {
      name: "Zamboanga Peninsula",
      description: "₱531.73 B (2.18%)",
      color: "rgb(155, 195, 235)",
    },
    PH10: {
      name: "Northern Mindanao",
      description: "₱1,180.09 B (4.85%)",
      color: "rgb(110, 150, 210)",
    },
    PH11: {
      name: "Davao",
      description: "₱1,255.05 B (5.16%)",
      color: "rgb(90, 130, 190)",
    },
    PH12: {
      name: "Soccsksargen",
      description: "₱620.37 B (2.55%)",
      color: "rgb(145, 185, 230)",
    },
    PH13: {
      name: "Caraga",
      description: "₱406.45 B (1.67%)",
      color: "rgb(170, 210, 240)",
    },
    PH14: {
      name: "Autonomous Region in Muslim Mindanao",
      description: "₱363.69 B (1.50%)",
      color: "rgb(175, 215, 245)",  // Lightest blue for lowest percentage
    },
    PH15: {
      name: "Cordillera Administrative Region",
      description: "₱410.56 B (1.69%)",
      color: "rgb(165, 205, 240)",
    },
    PH40: {
      name: "Calabarzon",
      description: "₱3,436.07 B (14.12%)",
      color: "rgb(20, 60, 140)",  // Very dark blue for second highest
    },
    PH41: {
      name: "Mimaropa",
      description: "₱472.21 B (1.94%)",
      color: "rgb(160, 200, 235)",
    },
  },
  labels: {
    PH00: {
      name: "National Capital Region",
      parent_id: "PH00",
    },
    PH01: {
      name: "Ilocos",
      parent_id: "PH01",
    },
    PH02: {
      name: "Cagayan Valley",
      parent_id: "PH02",
    },
    PH03: {
      name: "Central Luzon",
      parent_id: "PH03",
    },
    PH05: {
      name: "Bicol",
      parent_id: "PH05",
    },
    PH06: {
      name: "Western Visayas",
      parent_id: "PH06",
    },
    PH07: {
      name: "Central Visayas",
      parent_id: "PH07",
    },
    PH08: {
      name: "Eastern Visayas",
      parent_id: "PH08",
    },
    PH09: {
      name: "Zamboanga Peninsula",
      parent_id: "PH09",
    },
    PH10: {
      name: "Northern Mindanao",
      parent_id: "PH10",
    },
    PH11: {
      name: "Davao",
      parent_id: "PH11",
    },
    PH12: {
      name: "Soccsksargen",
      parent_id: "PH12",
    },
    PH13: {
      name: "Caraga",
      parent_id: "PH13",
    },
    PH14: {
      name: "Autonomous Region in Muslim Mindanao",
      parent_id: "PH14",
    },
    PH15: {
      name: "Cordillera Administrative Region",
      parent_id: "PH15",
    },
    PH40: {
      name: "Calabarzon",
      parent_id: "PH40",
    },
    PH41: {
      name: "Mimaropa",
      parent_id: "PH41",
    },
  },
  legend: {
    entries: [],
  },
  regions: {
  },
  data: {
    data: {},
  },
};
