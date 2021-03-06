Red/System [
	Title:	"Hidapi"
	Author: "Huang Yongzhao"
	File: 	%linux.reds
	Needs:	View
	Tabs: 	4
	Rights:  "Copyright (C) 2018 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

hid: context [

	;--symbolic names for the properties above
	#define DEVICE_STRING_MANUFACTURER  0
	#define DEVICE_STRING_PRODUCT       1
	#define DEVICE_STRING_SERIAL		2
	#define DEVICE_STRING_COUNT			3
	#define LOWORD(param) (param and FFFFh << 16 >> 16)   
	#define HIWORD(param) (param >> 16)
	#define _IOC(dir type nr size) ((dir << 30) or (type << 8) or (nr << 0) or (size << 16))
	#define HIDIOCSFEATURE(len)   (_IOC(3 (as integer! #"H")  06h  len))
	#define _IOC1(dir type nr size) ((dir << 30) or (type << 8) or (nr << 0) or (size << 16))
	#define HIDIOCGFEATURE(len)    (_IOC1(3 (as integer! #"H")  07h len))

	;--usb hid device property names
	device_string_names: ["manufacturer" "product"	"serial"]
	hid-device-info: alias struct! [
			path 				[c-string!]
			id 					[integer!] ;vendor-id and product-id
			serial-number 		[c-string!]
			manufacturer-string [c-string!]
			product-string 		[c-string!]
			usage 				[integer!] ;usage-page and usage
			release-number		[integer!]
			interface-number	[integer!]
			next				[hid-device-info]
		]
	pollfd: alias struct! [
		fd 			[integer!]
		events 		[integer!]  ;--events and revents
	]

	timespec!: alias struct! [
			sec    [integer!] ;Seconds
			nsec   [integer!] ;Nanoseconds
	]

	stat!: alias struct! [					;-- stat64 struct
					st_dev_l	  [integer!]
					st_dev_h	  [integer!]
					pad0		  [integer!]
					__st_ino	  [integer!]
					st_mode		  [integer!]
					st_nlink	  [integer!]
					st_uid		  [integer!]
					st_gid		  [integer!]
					st_rdev_l	  [integer!]
					st_rdev_h	  [integer!]
					pad1		  [integer!]
					st_size		  [integer!]
					st_blksize	  [integer!]
					st_blocks	  [integer!]
					st_atime	  [timespec! value]
					st_mtime	  [timespec! value]
					st_ctime	  [timespec! value]
					st_ino_h	  [integer!]
					st_ino_l	  [integer!]
					;...optional padding skipped
	]
	
	#import [
		LIBC-file cdecl [
			mbstowcs: "mbstowcs" [
				src 	[c-string!]
				dst 	[c-string!]
				len 	[integer!]
				return: [integer!]
			]
			wcsdup: "wcsdup" [
				s1 		[c-string!]
				return: [c-string!]
			]
			setlocale: "setlocale" [
				category 	[integer!]
				locale		[c-string!]
				return:		[byte-ptr!]
			]
			udev_new: "udev_new" [
				return: 	[int-ptr!]
			]
			udev_enumerate_new: "udev_enumerate_new" [
				udev		[int-ptr!]
				return: 	[int-ptr!]
			]
			udev_enumerate_add_match_subsystem: "udev_enumerate_add_match_subsystem" [
				udev_enumerate 	[int-ptr!]
				subsystem		[c-string!]
				return: 		[integer!]
			]
			udev_enumerate_scan_devices: "udev_enumerate_scan_devices" [
				udev_enumerate	[int-ptr!]
				return:			[integer!]
			]
			udev_enumerate_get_list_entry: "udev_enumerate_get_list_entry" [
				udev_enumerate 	[int-ptr!]
				return:			[int-ptr!]
			]
			udev_list_entry_get_next: "udev_list_entry_get_next" [
				list_entry		[int-ptr!]
				return: 		[int-ptr!]
			]
			udev_list_entry_get_name: "udev_list_entry_get_name" [
				list_entry		[int-ptr!]
				return:			[c-string!]
			]
			udev_device_new_from_syspath: "udev_device_new_from_syspath" [
				udev 			[int-ptr!]
				syspath 		[c-string!]
				return: 		[int-ptr!]
			]
			udev_device_get_devnode: "udev_device_get_devnode" [
				udev_device 	[int-ptr!]
				return: 		[c-string!]
			]
			udev_device_get_parent_with_subsystem_devtype: "udev_device_get_parent_with_subsystem_devtype" [
				udev_device 	[int-ptr!]
				subsystem 		[c-string!]
				devtype 		[c-string!]
				return: 		[int-ptr!]
			]
			udev_device_unref: "udev_device_unref" [
				udev_device 	[int-ptr!]
				return:			[int-ptr!]
			]
			strdup: "strdup" [
				src 		[c-string!]
				return: 	[c-string!]
			]
			strtok_r: "strtok_r" [
				s 			[c-string!]
				sep 		[c-string!]
				nextp 		[int-ptr!]
				return: 	[c-string!]
			]
			strchr: "strchr" [
				s 			[c-string!]
				n 			[integer!]
				return: 	[c-string!]
			]
			strcmp: "strcmp" [
				s1 			[c-string!]
				s2 			[c-string!]
				return: 	[integer!]
			]
			strncmp: "strncmp" [
				Str1 		[c-string!]
				Str2 		[c-string!]
				num 		[integer!]
				return: 	[integer!]
			]
			sscanf: "sscanf" [
				[variadic]
				return: 	[integer!]
			]
			strtol: "strtol" [
				str 		[c-string!]
				endptr 		[int-ptr!]
				base 		[integer!]
				return: 	[integer!]
			]
			udev_enumerate_unref: "udev_enumerate_unref" [
				udev_enumerate 	[int-ptr!]
				return:			[int-ptr!]
			]
			udev_unref: "udev_unref" [
				udev 			[int-ptr!]
				return: 		[int-ptr!]
			]
			wprintf: "wprintf" [
					[variadic]
					return: 	[integer!]
			]
			wcscmp: "wcscmp" [
				str1 		[c-string!]
				str2 		[c-string!]
				return: 	[integer!]
			]
			linux-open: "open" [
				str 		[c-string!]
				int 		[integer!]
				return: 	[integer!]
			]
			ioctl: "ioctl" [
				s1 			[integer!]
				s2 			[integer!]
				s3 			[int-ptr!]
				return: 	[integer!]
			]
			perror: "perror" [
				s 			[c-string!]
			]
			linux-write: "write" [
				fd 			[integer!]
				buf 		[c-string!]
				count 		[integer!]
				return: 	[integer!]
			]
			poll: "poll" [
				fds 		[pollfd]
				nfds 		[integer!]
				timeout 	[integer!]
				return: 	[integer!]
			]
			linux-read: "read" [
				fd 			[integer!]
				buf 		[c-string!]
				nbytes 		[integer!]
				return:		[integer!]
			]
			get-errno-ptr: "__errno_location" [
					return: [int-ptr!]
				]
			linux-close: "close" [
				handle 		[int-ptr!]
			]
			stat: "__fxstat" [
				version 	[integer!]
				file		[integer!]
				restrict	[stat!]
				return:		[integer!]
			]
			udev_device_new_from_devnum: "udev_device_new_from_devnum" [
				udev 		[int-ptr!]
				type 		[byte!]
				devnum1 	[integer!]
				devnum2 	[integer!]
				return: 	[int-ptr!]
			]
			wcsncpy: "wcsncpy" [
				dest 		[c-string!]
				src 		[c-string!]
				num 		[integer!]
				return: 	[c-string!]
			]

			wcsncmp: "wcsncmp" [
				str1 		[c-string!]
				str2 		[c-string!]
				num 		[integer!]
				return: 	[integer!]
			]
		]
		"libudev.so.1" cdecl[
			udev_device_get_sysattr_value: "udev_device_get_sysattr_value" [
				dev 	[int-ptr!]
				sysattr [c-string!]
				return: [c-string!]
			]
		]
	]


	hid-device: alias struct! [
		device_handle 			[integer!]
		blocking 				[integer!]
		uses-numbered-reports	[integer!]
	]

	new-hid-device: func [
		return: 	[hid-device]
		/local
			dev 		[hid-device]
	][
		dev: as hid-device allocate size? hid-device
		dev/device_handle: -1
		dev/blocking: 1
		dev/uses-numbered-reports: 0
		dev 
	]

	utf8-to-wchar-t: func [
		utf8 		[c-string!]
		return: 	[c-string!]
		/local
			ret 	[c-string!]
			wlen 	[integer!]
			a 		[integer!]
	][
		ret: null

		if utf8 <> null [
			wlen: mbstowcs null utf8 0 
			if -1 = wlen [
				return wcsdup ""
			]
			ret: as c-string! allocate (wlen + 1) * 4   ;--sizeof widechar
			set-memory as byte-ptr! ret null-byte (wlen + 1) * 4
			mbstowcs ret utf8 (wlen + 1) 
			a: 4 * wlen + 1
			ret/a: null-byte
			a: a + 1
			ret/a: null-byte
			a: a + 1
			ret/a: null-byte
			a: a + 1
			ret/a: null-byte
		]
		ret 
	]

	;--get an atrribute value from a udev_device and return it as wchar_t
	;--string the returned string must be freed with free（） when done
	copy-udev-string: func [
		dev 		[int-ptr!] ;--udev_device
		udev_name 	[c-string!] 
		return: 	[c-string!]
	][
		utf8-to-wchar-t (udev_device_get_sysattr_value dev udev_name)	
	]

	;--uses_numered_reports return 1 if report_descriptor describes a device 
	;--which contains numbered reports
	uses-numbered-reports: func [
		report_descriptor 	[byte-ptr!]
		size				[integer!]
		return: 			[integer!]
		/local
			i 				[integer!]
			size_code 		[integer!]
			data_len 		[integer!]
			key_size		[integer!]
			key 			[integer!]
			a 				[integer!]
	][
		i: 0
		while [i < size] [
			a: i + 1
			key: as integer! report_descriptor/a
			;--check for the report id key
			if key = 00000085h [return 1]
			
			either (key and 000000F0h) = 000000F0h [
				either (i + 1) < size [
					a: i + 2
					data_len: as integer! report_descriptor/a 
				][
					data_len: 0
				]
				key_size: 3
			][
				size_code: key and 00000003h
				switch size_code [
					0 		[data_len: size_code]
					1 		[data_len: size_code]
					2 		[data_len: size_code]
					3 		[data_len: 4]
					default [data_len: 0]
				]
				key_size: 1
			]
			i: i + data_len + key_size	
		]
		0	
	]

	hid-init: func [
		return: 	[integer!]
		/local
			locale	[byte-ptr!]
	][
		;--set the locale if it's not set
		locale: setlocale 0 null
		if locale = null [setlocale 0 ""]
		0
	]

	parse-uevent-info: func [
		uevent 				[c-string!]
		bus_type			[int-ptr!]
		vendor_id			[int-ptr!]
		product_id			[int-ptr!]
		serial_number_utf8	[int-ptr!]
		product_name_utf8	[int-ptr!]
		return: 			[integer!]
		/local
			tmp				[c-string!]
			saveptr			[integer!]
			line 			[c-string!]
			key 			[c-string!]
			value			[c-string!]
			found_id 		[integer!]
			found_serial	[integer!]
			found_name 		[integer!]
			ret 			[integer!]
			skip? 			[logic!]
	][
		found_id: 0 
		found_serial: 0
		found_name: 0 
		saveptr: 0
		tmp: strdup uevent
		line: strtok_r tmp "^(0A)" :saveptr
		while [line <> null] [
			;--line: "key=value"
			skip?: no 
			key: line
			value: strchr line as integer! #"=" 
			if value = null [
				;--goto next_line 
				skip?: yes 
			]
			unless skip? [
				value/1: null-byte
				value: value + 1
				case [
					(strcmp key "HID_ID") = 0 [
						ret: sscanf [value "%x:%hx:%hx" bus_type vendor_id product_id]
						if ret = 3 [
							found_id: 1
						]	
					]
					(strcmp key "HID_NAME") = 0 [
						product_name_utf8/value: as integer! strdup value
						found_name: 1
					]
					(strcmp key "HID_UNIQ") = 0 [
						serial_number_utf8/value: as integer! strdup value
						found_serial: 1
					]
					true []
				]
			]
			line: strtok_r null "^(0A)" :saveptr
		]
		free as byte-ptr! tmp 
		as integer! (all [found_id <> 0 found_name <> 0 found_serial <> 0])
		
	]

	enumerate: func [
		vendor_id 		[integer!]
		product_id 		[integer!]
		return: 		[hid-device-info]
		/local 	
			udev 					[int-ptr!]
			enumerate 				[int-ptr!]
			devices 				[int-ptr!]
			dev_list_entry			[int-ptr!]
			root 					[hid-device-info]
			cur_dev 				[hid-device-info]
			prev_dev				[hid-device-info]
			sysfs_path				[c-string!]
			dev_path				[c-string!]
			str						[c-string!]
			raw_dev					[int-ptr!]
			hid_dev 				[int-ptr!]
			usb_dev 				[int-ptr!]
			intf_dev 				[int-ptr!]
			dev_vid					[integer!]
			dev_pid 				[integer!]
			serial_number_utf8		[c-string!]
			product_name_utf8		[c-string!]
			bus_type				[integer!]
			result					[integer!]
			tmp 					[hid-device-info]
			product_name_utf8_fake 	[integer!]
			serial_number_utf8_fake	[integer!]
			skip? 					[logic!]
			skip1?					[logic!]
	][
		root: null
		cur_dev: null
		prev_dev: null
		hid-init

		;--create the udev object
		udev: udev_new 
		if udev = null [
			probe "can not create udev"
			return null
		]
		;--create a list of the device in the 'hidraw' subsystem
		enumerate: udev_enumerate_new udev
		udev_enumerate_add_match_subsystem enumerate "hidraw"
		udev_enumerate_scan_devices enumerate
		devices: udev_enumerate_get_list_entry enumerate	
		;--fir each item, see if it matchs the vid/pid and 
		;--if so create a udev_device record for it
		dev_list_entry: devices 
		while [dev_list_entry <> null] [
			;--get the filename of the /sys entry for the device 
			;--and create a udev_device object(dev) representing it
			skip?: no
			serial_number_utf8: null
			product_name_utf8: null
			bus_type: 0
			dev_vid: 0
			dev_pid: 0
			serial_number_utf8_fake: 0
			product_name_utf8_fake: 0
			sysfs_path: udev_list_entry_get_name dev_list_entry
			raw_dev: udev_device_new_from_syspath udev sysfs_path
			dev_path: udev_device_get_devnode raw_dev

			hid_dev: 	udev_device_get_parent_with_subsystem_devtype 	
						raw_dev
						"hid"
						null
			if hid_dev = null [
				;--unable to find parent hid device 
				skip?: yes 
			]
			unless skip? [
				result: parse-uevent-info 	
						(udev_device_get_sysattr_value hid_dev "uevent")
						:bus_type
						:dev_vid
						:dev_pid
						:serial_number_utf8_fake
						:product_name_utf8_fake 
				serial_number_utf8: as c-string! serial_number_utf8_fake
				product_name_utf8: as c-string! product_name_utf8_fake 
				if result = 0 [
					;--go to next 
					free as byte-ptr! serial_number_utf8
					free as byte-ptr! product_name_utf8
					udev_device_unref raw_dev 
					;--go to next
				]
				if all [bus_type <> 3 bus_type <> 5] [
					;--go to next 
					free as byte-ptr! serial_number_utf8
					free as byte-ptr! product_name_utf8
					udev_device_unref raw_dev 
					;--go to next
				]
				if all [
					any [vendor_id = 0  vendor_id = dev_vid]	
					any [product_id = 0 product_id = dev_pid]
					][
					tmp: as hid-device-info allocate size? hid-device-info
					either cur_dev <> null [
						cur_dev/next: tmp
					][
						root: tmp
					]
					prev_dev: cur_dev
					cur_dev: tmp

					;--fill out the record 
					cur_dev/next: null
					cur_dev/path: either dev_path <> null [strdup dev_path][null]

					;--vid/pid
					cur_dev/id: dev_vid << 16 or dev_pid

					;--serial number
					cur_dev/serial-number: utf8-to-wchar-t serial_number_utf8

					;--release number
					cur_dev/release-number: 0

					;--interface number
					cur_dev/interface-number: -1
					skip1?: no 
					switch bus_type [
						3 [
							usb_dev: 	udev_device_get_parent_with_subsystem_devtype 	
										raw_dev
										"usb"
										"usb_device"
							if usb_dev = null [
								free as byte-ptr! cur_dev/serial-number
								free as byte-ptr! cur_dev/path
								free as byte-ptr! cur_dev

								either prev_dev <> null [
									prev_dev/next: null
									cur_dev: prev_dev
								][
									root: null
									cur_dev: root
								]
									skip1?: yes 
							]
							unless skip1?[
								;--manufacturer and product strings 
								cur_dev/manufacturer-string: 	copy-udev-string 	
																usb_dev
																as c-string! device_string_names/1

								cur_dev/product-string: copy-udev-string 	
														usb_dev 
														as c-string! device_string_names/2				 
								;--release number
								str: udev_device_get_sysattr_value usb_dev "bcdDevice"
								cur_dev/release-number: either str <> null [strtol str null 16][0]

								;--get a handle to the interface's udev node
								intf_dev: 	udev_device_get_parent_with_subsystem_devtype	
											raw_dev
											"usb"
											"usb_interface"
								if intf_dev <> null [
									str: udev_device_get_sysattr_value intf_dev "bInterfaceNumber"
									cur_dev/interface-number: either str <> null [strtol str null 16][-1]
								]
							]							
						]
						5 [
							cur_dev/manufacturer-string: wcsdup ""
							cur_dev/product-string: utf8-to-wchar-t product_name_utf8
					
						]
						default []
					]
				]
			]
			;--go to next 
			free as byte-ptr! serial_number_utf8
			free as byte-ptr! product_name_utf8
			udev_device_unref raw_dev 
			;--go to next		
			dev_list_entry: udev_list_entry_get_next dev_list_entry
		]
		udev_enumerate_unref enumerate
		udev_unref udev 
		root 
	]

	free-enumeration: func [
		devs 		[hid-device-info]
		/local
			d 		[hid-device-info]
			next 	[hid-device-info]
	][
		d: devs 
		while [d <> null] [
			next: d/next
			free as byte-ptr! d/path
			free as byte-ptr! d/serial-number
			free as byte-ptr! d/manufacturer-string
			free as byte-ptr! d/product-string
			free as byte-ptr! d 
			d: next
		]	
	]

	open: func [
		vendor_id		[integer!]
		product_id		[integer!]
		serial-number	[c-string!]
		return: 		[int-ptr!]
		/local
			devs 			[hid-device-info]
			cur_dev			[hid-device-info]
			path_to_open	[c-string!]
			handle			[hid-device]
			id 				[integer!]
	][
		path_to_open: null
		handle: null

		devs: enumerate vendor_id product_id
		id: vendor_id << 16 + product_id
		cur_dev: devs 
		while [cur_dev <> null] [
			if cur_dev/id = id [
				either serial-number <> null [
					if (wcscmp serial-number cur_dev/serial-number) = 0 [
						path_to_open: cur_dev/path
						break
					]
				][
					path_to_open: cur_dev/path
					break
				]

			]
			cur_dev: cur_dev/next
		]
		if path_to_open <> null [
			handle: open-path path_to_open
		]
		free-enumeration devs 
		as int-ptr! handle		
	]

	open-path: func [
		path			[c-string!]
		return: 		[hid-device]
		/local
			dev 		[hid-device]
			res			[integer!]
			desc_size	[integer!]
			rpt_desc	[int-ptr!]
	][
		dev: null
		hid-init
		dev: new-hid-device
		res: 0 
		desc_size: 0
		;--open here
		dev/device_handle: linux-open path 2
		rpt_desc: system/stack/allocate 1025
		set-memory as byte-ptr! rpt_desc null-byte 4100
		;--if we have a good handle ,return it 
		either dev/device_handle > 0 [
			;--get the report descriptor
			set-memory as byte-ptr! rpt_desc null-byte 4100

			;--get report descriptor size 
			res: ioctl dev/device_handle -2147203071 :desc_size  
			if res < 0 [
				perror "HIDIOCGRDESCSIZE"
			]
			rpt_desc/1: desc_size
			res: ioctl dev/device_handle -1878767614 rpt_desc
			either res < 0 [
				perror "HIDIOCGRDESC"
			][
				dev/uses-numbered-reports: 	uses-numbered-reports 	
											as byte-ptr! (rpt_desc + 1)
											rpt_desc/1
			]
			return dev 
		][
			free as byte-ptr! dev 
			return null
		]
	]

	write: func [
		device 		[int-ptr!]
		data 		[byte-ptr!]
		length 		[integer!]
		return: 	[integer!]
		/local
			dev 			[hid-device]
			bytes_written	[integer!]
	][
		dev: as hid-device device
		bytes_written: linux-write dev/device_handle as c-string! data length
		bytes_written
	]

	read-timeout: func [
		device 			[int-ptr!]
		data 			[byte-ptr!]
		length 			[integer!]
		milliseconds	[integer!]
		return: 		[integer!]
		/local
			dev 		[hid-device]
			bytes_read	[integer!]
			ret 		[integer!]
			fds 		[pollfd value]
			errno 		[integer!]
	][
		dev: as hid-device device
		if milliseconds >= 0 [
			fds/fd: dev/device_handle
			fds/events: 1 
			ret: poll fds 1 milliseconds
			either any [ret = -1 ret = 0] [
				return ret 
			][
				if (LOWORD(fds/events) and (8 or 16 or 32)) <> 0 [
					return -1
				]
			]
		]
		bytes_read: linux-read dev/device_handle as c-string! data length
		errno: as integer! get-errno-ptr
		if all [
			bytes_read < 0
			any [errno = 11 errno = 115]
		][	
			bytes_read: 0
			]
		bytes_read
	]

	read: func [
		device 			[int-ptr!]
		data 			[byte-ptr!]
		length 			[integer!]	
		return: 		[integer!]
		/local
			dev 		[hid-device]
			block? 		[integer!]
	][	
		 dev: as hid-device device
		 block?: either dev/blocking <> 0 [-1][0]
?? block?
		 return read-timeout device data length block?
	]

	set-nonblocking: func [
		device		[int-ptr!]
		nonblock 	[integer!]
		return: 	[integer!]
		/local
			dev 	[hid-device]
	][
		dev: as hid-device device
		dev/blocking: either nonblock = 0 [1][0]
		0
	]

	send-feature-report: func [
		device 		[int-ptr!]
		data 		[byte-ptr!]
		length		[integer!]
		return: 	[integer!]
		/local
			res    	[integer!]
			dev  	[hid-device]
	][
		dev: as hid-device device
		res: ioctl dev/device_handle HIDIOCSFEATURE(length) as int-ptr! data 
		if res < 0 [
			perror "ioctl (SFEATURE)"
		]
		res 
	]

	get-feature-report: func [
		device 		[int-ptr!]
		data 		[byte-ptr!]
		length		[integer!]
		return: 	[integer!]
		/local
			res 	[integer!]
			dev 	[hid-device]
	][
		dev: as hid-device device
		res: ioctl dev/device_handle HIDIOCGFEATURE(length) as int-ptr! data 
		if res < 0 [
			perror "ioctl (GFEATURE)"
		]
		res  
	]

	close: func [
		device 		[int-ptr!]
		/local
			dev 	[hid-device]
	][
		dev: as hid-device device
		either dev = null [
			probe "dev is null"
		][
			linux-close as int-ptr! dev/device_handle
			free as byte-ptr! dev 
		]
	]
	get-device-string: func [
		device 		[int-ptr!]
		key 		[integer!]
		string		[c-string!]
		maxlen		[integer!]
		return: 	[integer!]
		/local
			udev						[int-ptr!]
			udev_dev					[int-ptr!]
			parent						[int-ptr!]
			hid_dev 					[int-ptr!]
			s 							[stat! value]
			ret 						[integer!]
			serial_number_utf8			[c-string!]
			product_name_utf8			[c-string!]
			dev 						[hid-device]
			dev_vid 					[integer!]
			dev_pid 					[integer!]
			bus_type					[integer!]
			retm 						[integer!]
			str 						[c-string!]
			key_str						[c-string!]
			a 							[integer!]
			serial_number_utf8_fake		[integer!]
			product_name_utf8_fake		[integer!]
	][
		dev: as hid-device device
		serial_number_utf8: null
		product_name_utf8: null
		serial_number_utf8_fake: 0
		product_name_utf8_fake: 0
		ret: -1 
		bus_type: 0
		dev_vid: 0
		dev_pid: 0
		;--create the udev object
		udev: udev_new
		if udev = null [
			probe "can not create udev"
			return -1
		]

		;--get the dev_t(major/minor numbers) from the file handle
		ret: stat 3 dev/device_handle s 
		if -1 = ret [return ret ]

		;--open a udev device from the dev_t,'c' means character device
		udev_dev: udev_device_new_from_devnum udev #"c" s/st_rdev_l s/st_rdev_h
		if udev_dev <> null [
			hid_dev:	udev_device_get_parent_with_subsystem_devtype 
						udev_dev
						"hid"
						null
			if hid_dev <> null [
				ret: 	parse-uevent-info
						(udev_device_get_sysattr_value hid_dev "uevent")
						:bus_type
						:dev_vid
						:dev_pid
						:serial_number_utf8_fake
						:product_name_utf8_fake 
				serial_number_utf8: as c-string! serial_number_utf8_fake
				product_name_utf8: as c-string! product_name_utf8_fake
				either bus_type = 5 [ ;--bluetooth is 05h
					switch key [
						0 [
							wcsncpy string "" maxlen
							ret: 0
						]
						1 [
							retm: mbstowcs string product_name_utf8 maxlen
							ret: either retm = -1 [-1][0]
						]
						2 [
							retm: mbstowcs string serial_number_utf8 maxlen
							ret: either retm = -1 [-1][0]
						]
						3 [
							ret: -1
						]
						default [
							ret: -1
						]
					]	
				][
					parent: udev_device_get_parent_with_subsystem_devtype
							udev_dev
							"usb"
							"usb_device"
					if parent <> null [
						key_str: null
						either all [key >= 0 key < 3] [
							a: key + 1
							key_str: as c-string! device_string_names/a 
						][
							ret: -1
							;--go to end
						]
						str: udev_device_get_sysattr_value parent key_str
						if str <> null [
							retm: mbstowcs string str maxlen
							ret: either -1 = retm [-1][0]
							;--go to end
						]
					]
				]
			]
		]
		free as byte-ptr! serial_number_utf8
		free as byte-ptr! product_name_utf8
		udev_device_unref udev_dev
		udev_unref udev
		ret 
	]

	red-get-manufacturer-string: func [
		device 		[int-ptr!]
		string 		[c-string!]
		maxlen 		[integer!]
		return: 	[integer!]
	][
		return 	get-device-string 
				device
				0
				string
				maxlen
	]

	red-get-product-string: func [
		device 		[int-ptr!]
		string 		[c-string!]
		maxlen		[integer!]
		return: 	[integer!]
	][
		return 	get-device-string 
				device
				1
				string
				maxlen
	]

	red-get-serial-number-String: func [
		device 		[int-ptr!]
		string 		[c-string!]
		maxlen 		[integer!]
		return: 	[integer!]
	][
		return 	get-device-string
				device
				2
				string
				maxlen
	]

	red-get-indexed-string: func [
		device 		[int-ptr!]
		str_index	[integer!]
		string 		[c-string!]
		maxlen 		[integer!]
		return: 	[integer!]
	][
		-1 
	]


]








