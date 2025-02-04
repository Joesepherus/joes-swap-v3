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
    PH01: {
      name: "Manila",
      description: "₱586,335",
      color: "rgb(71, 105, 171)",
    },
    PH02: {
      name: "Pateros",
      description: "₱162,676",
      color: "rgb(220, 231, 255)",
    },
    PH03: {
      name: "Quezon",
      description: "₱467,027",
      color: "rgb(95, 134, 191)",
    },
    PH04: {
      name: "Pasay",
      description: "₱884,858",
      color: "rgb(38, 71, 140)",
    },
    PH05: {
      name: "Caloocan South",
      description: "₱160,142",
      color: "rgb(230, 238, 255)",
    },
    PH06: {
      name: "Caloocan North",
      description: "₱160,142",
      color: "rgb(230, 238, 255)",
    },
    PH07: {
      name: "Mandaluyong",
      description: "₱723,963",
      color: "rgb(51, 89, 156)",
    },
    PH08: {
      name: "Makati",
      description: "₱2,065,053",
      color: "rgb(20, 39, 97)",
    },
    PH09: {
      name: "Muntinlupa",
      description: "₱533,899",
      color: "rgb(82, 120, 181)",
    },
    PH10: {
      name: "Pasig",
      description: "₱628,051",
      color: "rgb(64, 98, 164)",
    },
    PH11: {
      name: "Marikina",
      description: "₱274,485",
      color: "rgb(159, 188, 230)",
    },
    PH12: {
      name: "Las Piñas",
      description: "₱203,772",
      color: "rgb(185, 209, 245)",
    },
    PH13: {
      name: "Parañaque",
      description: "₱500,641",
      color: "rgb(89, 127, 186)",
    },
    PH14: {
      name: "Valenzuela",
      description: "₱284,963",
      color: "rgb(153, 183, 227)",
    },
    PH15: {
      name: "Malabon",
      description: "₱206,413",
      color: "rgb(182, 206, 243)",
    },
    PH16: {
      name: "Taguig",
      description: "₱606,373",
      color: "rgb(69, 103, 167)",
    },
    PH17: {
      name: "Navotas",
      description: "₱186,599",
      color: "rgb(198, 219, 250)",
    },
    PH18: {
      name: "San Juan",
      description: "₱828,670",
      color: "rgb(44, 77, 145)",
    },
  },
  labels: {
    // PH00: {
    //   name: "National Capital Region",
    //   parent_id: "PH00",
    // },
    // PH01: {
    //   name: "Ilocos",
    //   parent_id: "PH01",
    // },
    // PH02: {
    //   name: "Cagayan Valley",
    //   parent_id: "PH02",
    // },
    // PH03: {
    //   name: "Central Luzon",
    //   parent_id: "PH03",
    // },
    // PH05: {
    //   name: "Bicol",
    //   parent_id: "PH05",
    // },
    // PH06: {
    //   name: "Western Visayas",
    //   parent_id: "PH06",
    // },
    // PH07: {
    //   name: "Central Visayas",
    //   parent_id: "PH07",
    // },
    // PH08: {
    //   name: "Eastern Visayas",
    //   parent_id: "PH08",
    // },
    // PH09: {
    //   name: "Zamboanga Peninsula",
    //   parent_id: "PH09",
    // },
    // PH10: {
    //   name: "Northern Mindanao",
    //   parent_id: "PH10",
    // },
    // PH11: {
    //   name: "Davao",
    //   parent_id: "PH11",
    // },
    // PH12: {
    //   name: "Soccsksargen",
    //   parent_id: "PH12",
    // },
    // PH13: {
    //   name: "Caraga",
    //   parent_id: "PH13",
    // },
    // PH14: {
    //   name: "Autonomous Region in Muslim Mindanao",
    //   parent_id: "PH14",
    // },
    // PH15: {
    //   name: "Cordillera Administrative Region",
    //   parent_id: "PH15",
    // },
    // PH40: {
    //   name: "Calabarzon",
    //   parent_id: "PH40",
    // },
    // PH41: {
    //   name: "Mimaropa",
    //   parent_id: "PH41",
    // },
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
