Red/System []
hid: context [
	#define	EINVAL		22		;/* Invalid argument */
	#define kIOHIDSerialNumberKey               "SerialNumber"
	#define kIOHIDManufacturerKey               "Manufacturer"
	#define kIOHIDProductKey                    "Product"
	#define kIOHIDPrimaryUsagePageKey           "PrimaryUsagePage"
	#define kIOHIDPrimaryUsageKey               "PrimaryUsage"
	#define kIOHIDVersionNumberKey              "VersionNumber"
	#define kIOServicePlane						"IOService"
	#define kIOHIDVendorIDKey                   "VendorID"
	#define kIOHIDProductIDKey                  "ProductID"
	#define kIOHIDMaxInputReportSizeKey         "MaxInputReportSize"
	#define BUF_LEN 							256
	#define kCFNumberSInt32Type  				3
	#define kCFStringEncodingUTF8				08000100h
	#define CFSTR(cStr)							[CFStringCreateWithCString 0 cStr kCFStringEncodingUTF8]
	#define LOWORD(param) (param and FFFFh << 16 >> 16)   
	#define HIWORD(param) (param >> 16)
	#define WIDE_CHAR_SIZE						4
	#define kIOHIDOptionsTypeSeizeDevice		1
	#define kCFStringEncodingASCII				00000600h
	;#define kCFAllocatorDefault 				null
	;#define kIOMasterPortDefault				null
	#define kIOHIDReportTypeOutput 				1 
	#define	ETIMEDOUT							60
	
	
	hid_mgr: as int-ptr! 0
	kCFStringEncodingUTF32LE: 1C000100h

	timeval!: alias struct! [
		tv_sec	[integer!]
		tv_usec [integer!]
	]

	timespec!: alias struct! [
		sec    [integer!] ;Seconds
		nsec   [integer!] ;Nanoseconds
	]

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
	
	CFRange: alias struct! [
		location 	[integer!]
		length 		[integer!]
	]

	pthread_cond_t: alias struct! [
		__sig       [integer!]
		opaque1     [integer!]	;opaque size =24
		opaque2		[integer!]
		opaque3     [integer!]
		opaque4		[integer!]   
		opaque5     [integer!]
		opaque6		[integer!]    	       
	]

	pthread_mutex_t: alias struct! [
		__sig 		[integer!]
		opaque1     [integer!]	;opaque size =40
		opaque2		[integer!]
		opaque3     [integer!]
		opaque4		[integer!]   
		opaque5     [integer!]
		opaque6		[integer!]
		opaque7     [integer!]
		opaque8		[integer!]   
		opaque9     [integer!]
		opaque10	[integer!]     
	]	
	pthread_barrier_t: alias struct! [
		mutex       [pthread_mutex_t value]
		cond        [pthread_cond_t value]
		count       [integer!]
		trip_count  [integer!]
	]

	input_report: alias struct! [
		data 		[byte-ptr!]
		len 	 	[integer!]
		next 		[input_report]
	]

	#define pthread_t int-ptr!

	hid-device: alias struct! [
		device_handle 			[int-ptr!]
		blocking 				[integer!]
		uses_numbered_reports	[integer!]
		disconnected			[integer!]
		run_loop_mode 			[int-ptr!]
		run_loop 				[int-ptr!]
		source 					[int-ptr!]
		input_report_buf		[c-string!]
		max_input_report_len 	[integer!]  ;CFIndex alias int
		input_reports 			[input_report]

		thread 					[pthread_t]
		mutex 					[pthread_mutex_t value]   ;pthread_mutex_t is int
		condition 				[pthread_cond_t value]
		barrier 				[pthread_barrier_t value]
		shutdown_barrier 		[pthread_barrier_t value]
		shutdown_thread 		[integer!]
	]

	CFRunLoopSourceContext: alias struct! [
		version 			[integer!]
		info 				[int-ptr!]
		retain				[int-ptr!]
		release 			[int-ptr!]
		copyDescription		[int-ptr!]
		equal				[int-ptr!]
		hash 				[int-ptr!]
		schedule 			[int-ptr!]
		cancel 				[int-ptr!]
		perform 			[int-ptr!]					
	]

	#import [
		LIBC-file cdecl [
				sleep: "sleep" [
					n		[integer!]
				]
				strdup: "strdup" [
					str1 		[c-string!]
					return: 	[c-string!]
				]
				wcscpy: "wcscpy" [
					str1 		[c-string!]
					str2 		[c-string!]
					return: 	[c-string!]
				]
				wcscmp: "wcscmp" [
				string1		[c-string!]
				string2 	[c-string!]
				return: 	[integer!]
				]
				pthread_mutex_init: "pthread_mutex_init" [
					mutex 		[int-ptr!]
					attr 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_init: "pthread_cond_init" [
					cond 		[int-ptr!]
					attr 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_destroy: "pthread_mutex_destroy" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_destroy: "pthread_cond_destroy" [
					cond 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_lock: "pthread_mutex_lock" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_unlock: "pthread_mutex_unlock" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_broadcast: "pthread_cond_broadcast" [
					cond 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_wait: "pthread_cond_wait" [
					cond		[int-ptr!]
					mutex		[int-ptr!]
					return: 	[integer!]
				]
				wcslen: "wcslen" [
					wcs   		[c-string!]
					return: 	[integer!]
				]
				wprintf: "wprintf" [
					[variadic]
					return: 	[integer!]
				]
				pthread_create: "pthread_create" [
					restrict 	[int-ptr!]
					restrict1 	[int-ptr!]
					restrict2 	[int-ptr!]
					restrict3 	[int-ptr!]
					return: 	[integer!]
				]
				memcpy: "memcpy" [
					destination 	[byte-ptr!]
					source 			[byte-ptr!]
					size 			[integer!]
				]
				pthread_cond_signal: "pthread_cond_signal" [
					pthread_cond 	[int-ptr!]
					return: 		[integer!]
				]
				gettimeofday: "gettimeofday" [
					tv		[timeval!]
					tz		[integer!]			;-- obsolete
					return: [integer!]			;-- 0: success -1: failure
				]
				pthread_cond_timedwait: "pthread_cond_timedwait" [
					restrict	[int-ptr!]
					restrict1 	[int-ptr!]
					restrict3 	[timespec!]
					return: 	[integer!]
				]
		]
		"/System/Library/Frameworks/IOKit.framework/IOKit" cdecl [
			IOHIDDeviceGetProperty: "IOHIDDeviceGetProperty" [
				key 			[int-ptr!]
				device 			[c-string!] 
				return: 		[int-ptr!]
			]
			IOHIDDeviceGetService: "IOHIDDeviceGetService" [
				device 			[int-ptr!]
				return: 		[int-ptr!]
			]
			IORegistryEntryGetPath: "IORegistryEntryGetPath" [
				entry			[int-ptr!]
				plane 			[c-string!]   ;--size is 128
				path 			[c-string!]   ;--size is 512
				return: 		[integer!]
			]
			IOHIDManagerCreate: "IOHIDManagerCreate" [
				allocator 		[int-ptr!]
				options			[integer!]
				return: 		[int-ptr!]
			]
			IOHIDManagerSetDeviceMatching: "IOHIDManagerSetDeviceMatching" [
				manager 		[int-ptr!]
				matching		[int-ptr!]
			]
			IOHIDManagerScheduleWithRunLoop: "IOHIDManagerScheduleWithRunLoop" [
				manager 		[int-ptr!]
				runloop 		[int-ptr!]
				runLoopMode		[int-ptr!]
			]
			IOHIDManagerClose: "IOHIDManagerClose" [
				manager 		[int-ptr!]
				options			[integer!]
				return: 		[integer!]
			]
			IOHIDManagerCopyDevices: "IOHIDManagerCopyDevices" [
				manager			[int-ptr!]
				return: 		[int-ptr!]
			]
			IORegistryEntryFromPath: "IORegistryEntryFromPath" [
				masterPort 		[int-ptr!]
				path 			[c-string!]
				return: 		[int-ptr!]
			]
			IOObjectRelease: "IOObjectRelease" [
				object 		[int-ptr!]
				return: 	[integer!]
			]
			IOHIDDeviceCreate: "IOHIDDeviceCreate" [
				allocator 	[int-ptr!]
				service 	[int-ptr!]
				return: 	[int-ptr!]
			]
			IOHIDDeviceOpen: "IOHIDDeviceOpen" [
				device 		[int-ptr!]
				options 	[integer!]
				return: 	[integer!]
			]
			IOHIDDeviceRegisterInputReportCallback: "IOHIDDeviceRegisterInputReportCallback" [
				device 			[int-ptr!]
				report 			[byte-ptr!]
				reportlength	[integer!]
				callback 		[int-ptr!]  ;--Pointer to a callback method of type IOHIDReportCallback.
				context 		[int-ptr!]
			]
			IOHIDDeviceRegisterRemovalCallback: "IOHIDDeviceRegisterRemovalCallback" [
				device 			[int-ptr!]
				callback 		[int-ptr!]
				context 		[int-ptr!]
			]
			IOHIDDeviceScheduleWithRunLoop: "IOHIDDeviceScheduleWithRunLoop" [
				device 			[int-ptr!]
				runloop 		[int-ptr!]
				runLoopMode		[int-ptr!]
			]
			IOHIDDeviceSetReport: "IOHIDDeviceSetReport" [
				device 			[int-ptr!]
				type 			[integer!]
				reportID      	[integer!]
				report			[byte-ptr!]
				reportLength	[integer!]
				return: 		[integer!]
				]
		]
		"/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation" cdecl [
			kCFRunLoopDefaultMode: "kCFRunLoopDefaultMode" [integer!]
			kCFAllocatorDefault: "kCFAllocatorDefault" [integer!]
			kIOMasterPortDefault: "kIOMasterPortDefault" [integer!]
			CFStringCreateWithCString: "CFStringCreateWithCString" [
						allocator	[integer!]
						cStr		[c-string!]
						encoding	[integer!]
						return:		[int-ptr!]
					]
			CFRunLoopRunInMode: "CFRunLoopRunInMode" [
				mode 						[int-ptr!]
				seconds 					[float!]
				returnAfterSourceHandled	[logic!]
				return: 					[integer!]
			]
			CFSetGetCount: "CFSetGetCount" [
				theSet 			[int-ptr!]
				return: 		[integer!]
			]
			CFSetGetValues: "CFSetGetValues" [
				theSet 			[int-ptr!]
				values 			[int-ptr!]	
			]
			CFGetTypeID: "CFGetTypeID" [
				cf 			[int-ptr!]
				return: 	[integer!]
			]
			CFNumberGetTypeID: "CFNumberGetTypeID" [
				return: 	[integer!]
			]
			CFNumberGetValue: "CFNumberGetValue" [
				number 		[int-ptr!]
				theType 	[integer!]
				valuePtr	[int-ptr!]
				return: 	[logic!]
			]
			CFRelease: "CFRelease" [
				cf 			[int-ptr!]
			]
			CFStringGetLength: "CFStringGetLength" [
				theString 	[int-ptr!]
				return: 	[integer!]
			]
			CFStringGetBytes: "CFStringGetBytes" [
				theString					[int-ptr!]
				range 						[CFRange value]
				encoding					[integer!]
				lossByte					[byte!]
				isExternalRepresentation	[logic!]
				buffer 						[byte-ptr!]
				maxBufLen					[integer!]
				usedBufLen 					[int-ptr!]
				return: 					[integer!]
			]
			CFRunLoopGetCurrent: "CFRunLoopGetCurrent" [
				return: 				[int-ptr!]
			]
			CFRunLoopStop: "CFRunLoopStop" [
				rl   		[int-ptr!]
			]
			CFRunLoopSourceCreate: "CFRunLoopSourceCreate" [
				allocator 	[int-ptr!]
				order 		[integer!]
				context		[int-ptr!]
				return: 	[int-ptr!]
			]
			CFRunLoopAddSource: "CFRunLoopAddSource" [
				rl 			[int-ptr!]
				source 		[int-ptr!]
				mode 		[int-ptr!]
			]

		]
	]

	TIMEVAL_TO_TIMESPEC: func [
		tv 			[timeval!]
		ts 			[timespec!]
	][
		ts/sec: tv/tv_sec 
		ts/nsec: 1000 * tv/tv_usec
	]
	
	
	pthread_barrier_init: func [
		barrier 	[pthread_barrier_t]
		count 		[integer!]
		return: 	[integer!]
	][
		if count = 0 [
			return -1			
		]
		if (pthread_mutex_init :barrier/mutex null) < 0 [
			return -1
		]
		if (pthread_cond_init :barrier/cond null) < 0 [
			pthread_mutex_destroy :barrier/mutex
			return -1
		]
		barrier/trip_count: count
		barrier/count: 0
		0 
	]

	pthread_barrier_destroy: func [
		barrier 		[pthread_barrier_t]
		return: 		[integer!]
	][
		pthread_cond_destroy :barrier/cond
		pthread_mutex_destroy :barrier/mutex
		0
	]

	pthread_barrier_wait: function [
		barrier			[pthread_barrier_t]
		return: 		[integer!]
	][
		pthread_mutex_lock :barrier/mutex
		probe "lock-------- pthread_barrier_wait"
		barrier/count: barrier/count + 1
		probe ["barrier/count"barrier/count]
		probe ["barrier/trip_count"barrier/trip_count]
		either barrier/count >= barrier/trip_count [
			barrier/count: 0
			pthread_cond_broadcast :barrier/cond
			pthread_mutex_unlock :barrier/mutex
			return 1
		][
			pthread_cond_wait :barrier/cond :barrier/mutex
			pthread_mutex_unlock :barrier/mutex
			return 0
		]
	]


	new-hid-device: func [
		return: 	[hid-device]
		/local
		dev 		[hid-device]
	][
		dev: as hid-device allocate size? hid-device
		set-memory as byte-ptr! dev null-byte size? hid-device
		dev/device_handle: null
		dev/blocking: 1
		dev/uses_numbered_reports: 0
		dev/disconnected: 0
		dev/run_loop_mode: null
		dev/run_loop: null
		dev/source: null
		dev/input_report_buf: null
		dev/input_reports: null
		dev/shutdown_thread: 0

		pthread_mutex_init :dev/mutex null
		pthread_cond_init :dev/condition null
		pthread_barrier_init as pthread_barrier_t :dev/barrier 2
		pthread_barrier_init as pthread_barrier_t :dev/shutdown_barrier 2
		dev
	]

	free-hid-device: func [
		dev 		[hid-device]
		/local
		rpt 		[input_report value]
		next 		[input_report]
	][
		if dev = null [
		 	exit 
		]
		;--delete any input reports still left over
		rpt: dev/input_reports
		while [rpt <> null] [
			next: rpt/next
			free rpt/data
			free as byte-ptr! rpt
			rpt: next
		]

		;--free the string and report buffer. 
		if dev/run_loop_mode <> null [
			CFRelease dev/run_loop_mode
		]
		if dev/source <> null [
			CFRelease dev/source
		]
		free as byte-ptr! dev/input_report_buf
		
		;--clean up the thread objects
		pthread_barrier_destroy as pthread_barrier_t :dev/shutdown_barrier
		pthread_barrier_destroy as pthread_barrier_t :dev/barrier
		pthread_cond_destroy :dev/condition
		pthread_mutex_destroy :dev/mutex

		;--free the structure itself
		free as byte-ptr! dev 
	]

	hid-free-enumeration: func [
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

	get_int_property: func [
		device 			[int-ptr!]
		key				[c-string!]
		return: 		[integer!]
		/local
			ref 		[int-ptr!]
			value 		[integer!]
	][
		value: 0
		ref: IOHIDDeviceGetProperty device key
		if ref <> null [
			if (CFGetTypeID ref) = CFNumberGetTypeID [
				CFNumberGetValue 	ref
			 	 					kCFNumberSInt32Type
				  					:value
			return value
			]
		]
		return 0
	]

	get_vendor_id: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][
		return get_int_property device as c-string! CFSTR(kIOHIDVendorIDKey)
	]

	get_product_id: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][
		return get_int_property device as c-string! CFSTR(kIOHIDProductIDKey)
	]

	get_max_report_length: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][ 
		return get_int_property device as c-string! CFSTR(kIOHIDMaxInputReportSizeKey)
	]

	get_string_property: func [
		device 		[int-ptr!]
		prop 		[c-string!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
		/local
			cf-str 			[int-ptr!]	
			str_len 		[integer!]
			used_buf_len	[integer!]
			chars_copied	[integer!]	
			range 			[CFRange value]
			len1 			[integer!]
	][
		used_buf_len: 0
		probe ["len:" len]
		if len = 0 [
			return 0
		]
		cf-str: IOHIDDeviceGetProperty device prop
		buf/1: null-byte
		buf/2: null-byte
		either cf-str <> null [
			str_len: CFStringGetLength cf-str
			len: len - 1
			range/location: 0
			either str_len > len [
				range/length: len 
			][
				range/length: str_len
			]
			chars_copied: CFStringGetBytes cf-str
											range
											kCFStringEncodingUTF32LE
											#"?"
											false
											as byte-ptr! buf 
											len * WIDE_CHAR_SIZE
											:used_buf_len
			either chars_copied = len [
				len1: len * 4 + 1
				buf/len1: null-byte
				len1: len + 1
				buf/len1: null-byte
			][
				len1: chars_copied * 4 + 1
				buf/len1: null-byte
				len1: len +1
				buf/len1: null-byte
			]
			return 0
		][
			return -1
		]
	]
	
	get_serial_number: func [
		device 		[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][
		return get_string_property device (as c-string! CFSTR(kIOHIDSerialNumberKey)) buf len 
	]

	get_manufacturer_string: func [
		device 	 	[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][		
		return get_string_property device as c-string! CFSTR(kIOHIDManufacturerKey) buf len 
	]

	get_product_string: func [
		device 		[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
	][
		get_string_property device as c-string! CFSTR(kIOHIDProductKey) buf len 	
	]

	;--implementation of wcsdup() for mac
	dup_wcs: func [
		s 			[c-string!]
		return: 	[c-string!]
		/local
			len		[integer!]
			ret  	[c-string!]
	][
		len: wcslen s 
		ret: as c-string! allocate (len + 1) * WIDE_CHAR_SIZE
		wcscpy ret s
	]

	;--initialize the iohidmanager.return 0 for success and -1 for failure
	init_hid_manager: func [
		return: 	[integer!]
	][
probe "before hid_mgr"
		hid_mgr: IOHIDManagerCreate as int-ptr! kCFAllocatorDefault 0
?? hid_mgr
		if hid_mgr <> null [
			IOHIDManagerSetDeviceMatching hid_mgr null
			IOHIDManagerScheduleWithRunLoop hid_mgr 
											CFRunLoopGetCurrent 
											as int-ptr! kCFRunLoopDefaultMode
			return 0
		]
		return -1
	]

	;--initialize the iohidmanager if necessary. this is the public function
	hid_init: func [
		return: 	[integer!]
	][
?? hid_mgr
		if hid_mgr = null [
			return init_hid_manager 
		]
probe "hid_init1"
		return 0
	]

	hid_exit: func [
		return: 	[integer!]
	][
		if hid_mgr <> null [
			IOHIDManagerClose hid_mgr 0
			CFRelease hid_mgr
			hid_mgr: null
		]
		0
	]
	
	process_pending_events: func [
		/local
			res  [integer!]
	][
		until [
			res: CFRunLoopRunInMode as int-ptr! kCFRunLoopDefaultMode 0.001 false
			probe ["res!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!---------"res]
			any [res = 1  res = 3]
		]
	]


	;--hid_enumerate func
	enumerate: func [
		vendor-id	[integer!]
		product-id 	[integer!]
		return: 	[hid-device-info]
		/local 
			root 			[hid-device-info]
			cur_dev 		[hid-device-info]
			num_devices		[integer!]
			i 				[integer!]
			device_set 		[int-ptr!]
			device_array	[int-ptr!]
			dev_vid			[integer!]
			dev_pid			[integer!]
			buf 			[c-string!]
			dev 			[int-ptr!]
			tmp 			[hid-device-info]
			iokit_dev 		[int-ptr!]
			res 			[integer!]  ;--kern_return_t is int
			path			[c-string!]
			x 				[integer!]
			y 				[integer!]
	][
		root: null
		cur_dev: null
		path: as c-string! system/stack/allocate 128
		buf: as c-string! system/stack/allocate 256
		;--set up the hid manager if it has not been done
		if hid_init < 0 [
			return null
		]
		;--give the iohidmanager a chance to updata itself
		;probe "before process pending"
		process_pending_events

		;--get a list of the devices 
		IOHIDManagerSetDeviceMatching hid_mgr null
		device_set: IOHIDManagerCopyDevices hid_mgr

		;--convert the list into a c array so we can iterate easily
		num_devices: CFSetGetCount device_set
		device_array: as int-ptr! allocate 4 * num_devices
		CFSetGetValues device_set device_array ;--typecasting (const void **)


		;--irerate over each device, making an entry for it
		i: 1
		while [i < (num_devices + 1)] [
			dev: as int-ptr! device_array/i
; probe ["dev:" dev]
			if dev = null [
				continue 
			]
			dev_vid: get_vendor_id dev 
			dev_pid: get_product_id dev 
; probe ["vendor_id:" dev_vid]
; probe ["product_id:" dev_pid]
			;--check the vid/pid against the arguments

			if all [
				any [vendor-id = 0  vendor-id = dev_vid]
				any [product-id = 0  product-id = dev_pid] 
			][
				;--vid/pid match create the record
				tmp: as hid-device-info allocate size? hid-device-info
				either cur_dev <> null [
					cur_dev/next: tmp
				][
					root: tmp
				]
				cur_dev: tmp
			
			
; ?? cur_dev
			;--get the usage page and usage for this device
			x: get_int_property dev as c-string! CFSTR(kIOHIDPrimaryUsagePageKey)
; probe 1
			y: get_int_property dev as c-string! CFSTR(kIOHIDPrimaryUsageKey)
; probe 2
			cur_dev/usage: x << 16 or y  
; probe "cur_dev/usage!!!!!!!!!!!!!!!!"
			;--fill out the record
			cur_dev/next: null

			;--fill in the path (ioservice plane)
			iokit_dev: IOHIDDeviceGetService dev
			res: IORegistryEntryGetPath iokit_dev 
										kIOServicePlane  ;--have not defined
										path
			cur_dev/path: either res = 0 [strdup path][strdup ""]
	
			;--serial number
			get_serial_number dev buf BUF_LEN
;probe "buf:"
;wprintf buf
;probe " "
			cur_dev/serial-number: dup_wcs buf
; probe "cur_dev/serial-number:" 
; wprintf cur_dev/serial-number
; probe "serial-number finished"

			;--manufacturer and product strings
			get_manufacturer_string dev buf BUF_LEN
			cur_dev/manufacturer-string: dup_wcs buf 
; probe "cur_dev/manufacturer-string:"
; wprintf cur_dev/manufacturer-string
; probe " "
			get_product_string dev buf BUF_LEN
;dump-hex as byte-ptr! buf 
			cur_dev/product-string: dup_wcs buf 
;dump-hex as byte-ptr! cur_dev/product-string
; probe "cur_dev/product-string:"
; wprintf cur_dev/product-string
; probe " "
; probe " "
; probe " "
; probe " "
			;--vip/pid
			cur_dev/id: dev_vid << 16 or dev_pid
; probe "before get_int"
			;--release number 
; probe [dev " " CFSTR(kIOHIDVersionNumberKey)]
			cur_dev/release-number: get_int_property dev as c-string! CFSTR(kIOHIDVersionNumberKey)							 
; probe "after get_int"			
			;--interface number
			cur_dev/interface-number: -1
		]
			i: i + 1	
		]

		free as byte-ptr! device_array
		CFRelease device_set

		return root
	]


	open: func [
		vendor-id 		[integer!]
		product-id		[integer!]
		serial-number 	[c-string!]
		return: 		[int-ptr!]
		/local
			devs 			[hid-device-info]
			cur_dev 		[hid-device-info]
			path_to_open 	[c-string!]
			handle 			[hid-device]
	][
		devs: enumerate 0 0
		cur_dev: devs 
		while [cur_dev <> null] [
			if all [HIWORD(cur_dev/id) = vendor-id  LOWORD(cur_dev/id) = product-id] [
				either serial-number <> null [
					if 0 = wcscmp serial-number cur_dev/serial-number [
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
probe "helloworld"
			handle: open_path path_to_open
probe "after open_path"
		]

probe "before hid-free-enumeration"	
		hid-free-enumeration devs 
		as int-ptr! handle	
	]

	open_path: func [
		path		[c-string!]
		return: 	[hid-device]
		/local
			dev 	[hid-device]
			entry 	[int-ptr!]
			ret		[integer!]
			str 	[c-string!]
			b		[integer!]
			tmp 	[c-string!]
			tmp1 	[c-string!]
	][
		probe ["hid_device's size is:" size? hid-device]
		entry: null
		dev: new-hid-device
		str: as c-string! system/stack/allocate 8
		if hid_init < 0 [
			return null
		]
		entry: IORegistryEntryFromPath as int-ptr! kIOMasterPortDefault path
		if entry = null [
			;--path was not valid 
			;--return_error
			if dev/device_handle <> null [
				CFRelease dev/device_handle
			]
			if entry <> null [
				IOObjectRelease entry
			]
			free-hid-device dev 
			return null	
			;-------------return_error
		]
?? entry
; IOHIDDeviceCreate as int-ptr! kCFAllocatorDefault entry
		;--create and IOGIDDevice for entry
; IOHIDDeviceCreate null entry
		dev/device_handle: IOHIDDeviceCreate as int-ptr! kCFAllocatorDefault entry
;IOHIDDeviceCreate null entry
		if dev/device_handle = null [
			;--return_error
			if dev/device_handle <> null [
				CFRelease dev/device_handle
			]
			if entry <> null [
				IOObjectRelease entry
			]
			free-hid-device dev 
			return null	
			;-------------return_error
		]
		;--open the IOHIDDevice
		ret: IOHIDDeviceOpen dev/device_handle kIOHIDOptionsTypeSeizeDevice
?? ret
		either ret = 0 	[ ;--return success
			;--create the buffers for receiving data 
			dev/max_input_report_len: get_max_report_length dev/device_handle
			dev/input_report_buf:  as c-string! allocate dev/max_input_report_len
			set-memory as byte-ptr! dev/input_report_buf null-byte dev/max_input_report_len
			;--create the run loop mode for this device.
			;--printing the reference seems to work
			sprintf [str "HIDAPI_%p" dev/device_handle]
; 			tmp: "HIDAPI_"
; 			tmp1: as c-string! dev/device_handle
; probe tmp1
; 			copy-memory as byte-ptr! str as byte-ptr! tmp length? tmp
; 			copy-memory as byte-ptr! (str + 6) as byte-ptr! tmp1 length? tmp1
			dev/run_loop_mode: CFStringCreateWithCString 	0 
															str
															kCFStringEncodingASCII
			;--attach the device to a run loop
			IOHIDDeviceRegisterInputReportCallback 	dev/device_handle
													as byte-ptr! dev/input_report_buf
													dev/max_input_report_len
													as int-ptr! :hid_report_callback
													as int-ptr! dev 
			
			IOHIDDeviceRegisterRemovalCallback 	dev/device_handle
												as int-ptr! :hid_device_removal_callback
												as int-ptr! dev 

			;--start the read thread
			b: pthread_create :dev/thread  
										null	
										as int-ptr! :read_thread
										as int-ptr! dev 	
?? b	
			;--wait here for the read thread to be initialized
			pthread_barrier_wait as pthread_barrier_t :dev/barrier
probe "main thread wait done"
			IOObjectRelease entry
			return dev 									
		][
			if dev/device_handle <> null [
				CFRelease dev/device_handle
			]
			if entry <> null [
				IOObjectRelease entry
			]
			free-hid-device dev 
			return null	
		]

		
	]

	hid_device_removal_callback: func [
		[cdecl]
		context 	[int-ptr!]
		result 		[integer!]
		sender 		[int-ptr!]
		/local
			d 		[hid-device]
	][
		d: as hid-device context
		d/disconnected: 1
		CFRunLoopStop d/run_loop
	]

	hid_report_callback: func [
		[cdecl]
		context 		[int-ptr!]
		result 			[integer!]
		sender 			[int-ptr!]
		report_type		[integer!]
		report_id 		[integer!]
		report 			[byte-ptr!]
		report_length 	[integer!]
		/local
			rpt 		[input_report]
			dev 		[hid-device]
			cur 		[input_report]
			num_queued	[integer!]
	][
		probe "begain to hid_report_callback!!!!!!!!!!!!!!!!!!!!!!!!"
		dev: as hid-device context   
		;--make a new input report object 
		rpt: as input_report allocate size? input_report
		rpt/data: allocate report_length
		memcpy rpt/data report report_length
		rpt/len: report_length
		rpt/next: null

		;--lock this section
		pthread_mutex_lock :dev/mutex
		probe "lock------------hid_report_callback"
		;--attach the new report object to the end of the list 
		either dev/input_reports = null [
			dev/input_reports: rpt
		][
			;--find the end of the list and attach
			cur: dev/input_reports 
			num_queued: 0
			while [cur/next <> null] [
				cur: cur/next 
				num_queued: num_queued + 1
			]
			cur/next: rpt 

			if num_queued > 30 [
				return_data dev null 0
			]

		]
		pthread_cond_signal :dev/condition

		;--unclock
		pthread_mutex_unlock :dev/mutex 
		
	]

	return_data: func [
		dev 		[hid-device]
		data 		[byte-ptr!]
		length		[integer!]
		return: 	[integer!]
		/local 
			rpt		[input_report]
			len 	[integer!]
	][
		rpt: dev/input_reports
		len: either length < rpt/len [length][rpt/len]
		memcpy data rpt/data len 
		dev/input_reports: rpt/next 
		free rpt/data 
		free as byte-ptr! rpt 
		len 
	]

	read_thread: func [
		[cdecl]
		param 		[int-ptr!]
		return: 	[int-ptr!]
		/local
			dev		[hid-device]
			code 	[integer!]
			ctx 	[CFRunLoopSourceContext value]
			a		[integer!]

	][	
		code: 0
		dev: as hid-device param
		;--move the device's  run loop to this thread
		IOHIDDeviceScheduleWithRunLoop  dev/device_handle
										CFRunLoopGetCurrent
										dev/run_loop_mode
		probe "begain devic's runloop~~~~~~~~~~"
		;--create the runloopsource which is used to signal the event loop to\
		;--stop when hid_close is called
?? dev 
		set-memory as byte-ptr! ctx null-byte size? CFRunLoopSourceContext
		ctx/version: 0
		ctx/info: as int-ptr! dev 
		ctx/perform: as int-ptr! :perform_signal_callback
dump-hex as byte-ptr! ctx
		dev/source: CFRunLoopSourceCreate as int-ptr! kCFAllocatorDefault 0 as int-ptr! :ctx
		CFRunLoopAddSource  CFRunLoopGetCurrent dev/source dev/run_loop_mode

		;--stire off the run loop so it can be stopped from hid_close
		;--and on device disconnection
		dev/run_loop: CFRunLoopGetCurrent
		;--notify the main thread that the read thread is up and running
		a: pthread_barrier_wait as pthread_barrier_t :dev/barrier
?? a
probe  dev/shutdown_thread
probe 	dev/disconnected
probe  "hello2"	
probe 	" "
probe 	" "	
		;--run the event loop so it can be stopped from hid_close
		;--and on device disconnection

		while [all [dev/shutdown_thread = 0 dev/disconnected = 0]] [
probe "hello4"
probe ["code:"code]
probe " "
probe " "
			code: CFRunLoopRunInMode dev/run_loop_mode 1000.0 false
probe  "hello2223"
probe ["code:"code]
			;--return if the device has been disconnected
			if code = 1 [
				dev/disconnected: 1
				break
			]

			;--break if the run loop returns finished or stopped
			if all [code <> 3  code <> 4] [
				dev/shutdown_thread: 1
				break
			]
		]
		pthread_mutex_lock :dev/mutex
		probe "lock------read_thread"
probe ["dev/mutex"dev/mutex]
		pthread_cond_broadcast :dev/condition
probe ["dev/condition" dev/condition]
		pthread_mutex_unlock :dev/mutex
probe ["dev/mutex"dev/mutex	]	

		pthread_barrier_wait as pthread_barrier_t  :dev/shutdown_barrier

		null		
	]

	perform_signal_callback: func [
		[cdecl]
		context 	[int-ptr!]
		/local
			dev 	[hid-device]
	][
		dev: as hid-device context 
		CFRunLoopStop dev/run_loop
	]

	write: func [
		device 		[int-ptr!]
		data 		[byte-ptr!]
		length 		[integer!]
		return: 	[integer!]
		/local
			dev 	[hid-device]
	][
		dev: as hid-device device
		set_report dev kIOHIDReportTypeOutput data length
	]

	set_report: func [
		dev 		[hid-device]
		type 		[integer!]
		data 		[byte-ptr!]
		length 		[integer!]
		return: 	[integer!]
		/local
			data_to_send 	[byte-ptr!]
			length_to_send 	[integer!]
			res 			[integer!] 		
	][
		if dev/disconnected <> 0 [
			return -1
		]

		either data/1 = null-byte [
			data_to_send: data + 1
			length_to_send: length - 1
		][
			data_to_send: data
			length_to_send: length
		]

		if dev/disconnected = 0 [
			res: IOHIDDeviceSetReport 	dev/device_handle
										type
										as integer! data/1 
										data_to_send
										length_to_send
			
			either res = 0 [ ;--means success
				return length
			][
				return -1 
			]
		]
		return -1 
	]

	read: func [
		device 		[int-ptr!]
		data 		[byte-ptr!]
		length 		[integer!]
		return: 	[integer!]
		/local
			dev 	[hid-device]
			ms 		[integer!]
	][
		dev: as hid-device device
		ms: either dev/blocking <> 0 [-1][0]
		read_timeout device data length ms
	]

	read_timeout: func [
		device 			[int-ptr!]
		data 			[byte-ptr!]
		length			[integer!]
		milliseconds	[integer!]
		return: 		[integer!]
		/local
			dev 		[hid-device]
			bytes_read	[integer!]
			res 		[integer!]
			ts 			[timespec! value]
			tv 			[timeval! value]
	][
		dev: as hid-device device
		bytes_read: -1
		pthread_mutex_lock :dev/mutex
		probe "lock-----timeout"
		if dev/input_reports <> null [
			probe "dev/inoyt_reports <> null"
			bytes_read: return_data dev data length
			;--unlock
			pthread_mutex_unlock :dev/mutex
			return bytes_read
			;--unlock section
		]
probe 1
		if dev/disconnected <> 0 [
			bytes_read: -1
			;--unlock
			pthread_mutex_unlock :dev/mutex
			return bytes_read
			;--unlock section
		]
probe 2
		if dev/shutdown_thread <> 0 [
			bytes_read: -1
			;--unlock
			pthread_mutex_unlock :dev/mutex
			return bytes_read
			;--unlock section
		]
probe 3
		case [ 
			milliseconds = -1 [
				res: cond_wait dev :dev/condition :dev/mutex
				either res = 0 [
					bytes_read: return_data dev data length
				][
					bytes_read: -1
				]
			]
			milliseconds > 0 [ probe 4
				gettimeofday  tv  0
				TIMEVAL_TO_TIMESPEC tv ts 
				ts/sec: ts/sec + (milliseconds / 1000)
				ts/nsec: ts/nsec + ((milliseconds % 1000) * 1000000)
				if ts/nsec >= 1000000000 [
					ts/sec: ts/sec + 1
					ts/nsec: ts/nsec - 1000000000
				]
				res: cond_timedwait dev :dev/condition :dev/mutex ts 
				?? res
				case [
					res = 0 [bytes_read: return_data dev data length]
					res = ETIMEDOUT [bytes_read: 0]
					true [bytes_read: -1]
					]
			]
			true [bytes_read: 0]
		]
		;--unlock
		pthread_mutex_unlock :dev/mutex
		return bytes_read
		;--unlock section
	]

	cond_wait: func [
		dev 		[hid-device]
		cond 		[int-ptr!]
		mutex 		[int-ptr!]
		return: 	[integer!]
		/local
			res 	[integer!]
	][
		while [dev/input_reports = null] [
			res: pthread_cond_wait cond mutex 
			if res <> 0 [return res ]
			if  any [dev/shutdown_thread <> 0 dev/disconnected <> 0][return -1]
		]
		0	
	]

	cond_timedwait: func [
		dev 		[hid-device]
		cond 		[int-ptr!]
		mutex		[int-ptr!]
		abstime 	[timespec!]
		return: 	[integer!]
		/local 
			res 	[integer!]
	][
		while [dev/input_reports = null] [
			res: pthread_cond_timedwait cond mutex abstime
			if res <> 0 [return res ]
			if any [dev/shutdown_thread <> 0 dev/disconnected <> 0][return -1]
		]
		0
	]











]
