/* -*- mode: C; c-basic-offset: 4; tab-width: 4 -*-
 *
 * Copyright (c) 2008 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */
 

#ifndef __COMPACT_UNWIND_ENCODING__
#define __COMPACT_UNWIND_ENCODING__

#include <stdint.h>


// 
// Each final linked mach-o image has an optional __TEXT, __unwind_info section.
// This section is much smaller and faster to use than the __eh_frame section.
//



//
// Compilers usually emit standard Dwarf FDEs.  The linker recognizes standard FDEs and
// synthesizes a matching compact_unwind_encoding_t and adds it to the __unwind_info table.
// It is also possible for the compiler to emit __unwind_info entries for functions that 
// have different unwind requirements at different ranges in the function.
//
typedef uint32_t compact_unwind_encoding_t;



//
// The __unwind_info section is laid out for an efficient two level lookup.
// The header of the section contains a coarse index that maps function address
// to the page (4096 byte block) containing the unwind info for that function.  
//

#define UNWIND_SECTION_VERSION 1
struct unwind_info_section_header
{
	uint32_t	version;			// UNWIND_SECTION_VERSION
	uint32_t	commonEncodingsArraySectionOffset;
	uint32_t	commonEncodingsArrayCount;
	uint32_t	personalityArraySectionOffset;
	uint32_t	personalityArrayCount;
	uint32_t	indexSectionOffset;
	uint32_t	indexCount;
	// compact_unwind_encoding_t[]
	// uintptr_t personalities[]
	// unwind_info_section_header_index_entry[]
	// unwind_info_section_header_lsda_index_entry[]
};

struct unwind_info_section_header_index_entry 
{
	uint32_t		functionOffset;
	uint32_t		secondLevelPagesSectionOffset;	// section offset to start of regular or compress page
	uint32_t		lsdaIndexArraySectionOffset;	// section offset to start of lsda_index array for this range
};

struct unwind_info_section_header_lsda_index_entry 
{
	uint32_t		functionOffset;
	uint32_t		lsdaOffset;
};

//
// There are two kinds of second level index pages: regular and compressed.
// A compressed page can hold up to 1021 entries, but it cannot be used
// if too many different encoding types are used.  The regular page holds
// 511 entries.  
//

struct unwind_info_regular_second_level_entry 
{
	uint32_t					functionOffset;
	compact_unwind_encoding_t	encoding;
};

#define UNWIND_SECOND_LEVEL_REGULAR 2
struct unwind_info_regular_second_level_page_header
{
	uint32_t	kind;	// UNWIND_SECOND_LEVEL_REGULAR
	uint16_t	entryPageOffset;
	uint16_t	entryCount;
	// entry array
};

#define UNWIND_SECOND_LEVEL_COMPRESSED 3
struct unwind_info_compressed_second_level_page_header
{
	uint32_t	kind;	// UNWIND_SECOND_LEVEL_COMPRESSED
	uint16_t	entryPageOffset;
	uint16_t	entryCount;
	uint16_t	encodingsPageOffset;
	uint16_t	encodingsCount;
	// 32-bit entry array	
	// encodings array
};

#define UNWIND_INFO_COMPRESSED_ENTRY_FUNC_OFFSET(entry)			(entry & 0x00FFFFFF)
#define UNWIND_INFO_COMPRESSED_ENTRY_ENCODING_INDEX(entry)		((entry >> 24) & 0xFF)



// architecture independent bits
enum {
	UNWIND_IS_NOT_FUNCTION_START		= 0x80000000,
	UNWIND_HAS_LSDA						= 0x40000000,
	UNWIND_PERSONALITY_MASK				= 0x30000000,
};



// i386 specific bits
enum {
	UNWIND_X86_CASE_MASK				= 0x0000003F,
	UNWIND_X86_STACK_SIZE				= 0x000FFFC0,
	UNWIND_X86_STACK_ADJUST				= 0x00700000,
										  
	UNWIND_X86_UNWIND_INFO_UNSPECIFIED	= 0x00000000,
	UNWIND_X86_EBP_FRAME_NO_REGS		= 0x00000001,
	UNWIND_X86_EBP_FRAME_EBX			= 0x00000002,
	UNWIND_X86_EBP_FRAME_ESI			= 0x00000003,
	UNWIND_X86_EBP_FRAME_EDI			= 0x00000004,
	UNWIND_X86_EBP_FRAME_EBX_ESI		= 0x00000005,
	UNWIND_X86_EBP_FRAME_ESI_EDI		= 0x00000006,
	UNWIND_X86_EBP_FRAME_EBX_ESI_EDI	= 0x00000007,
	UNWIND_X86_EBP_FRAME_EBX_EDI		= 0x0000001A,
	UNWIND_X86_IMM_STK_NO_REGS			= 0x00000008,
	UNWIND_X86_IMM_STK_EBX				= 0x00000009,
	UNWIND_X86_IMM_STK_ESI				= 0x0000000A,
	UNWIND_X86_IMM_STK_EDI				= 0x0000000B,
	UNWIND_X86_IMM_STK_EBX_ESI			= 0x0000000C,
	UNWIND_X86_IMM_STK_ESI_EDI			= 0x0000000D,
	UNWIND_X86_IMM_STK_ESI_EDI_EBP      = 0x0000000E,
	UNWIND_X86_IMM_STK_EBX_ESI_EDI		= 0x0000000F,
	UNWIND_X86_IMM_STK_EBX_ESI_EDI_EBP  = 0x00000010,
	UNWIND_X86_IND_STK_NO_REGS			= 0x00000011,
	UNWIND_X86_IND_STK_EBX				= 0x00000012,
	UNWIND_X86_IND_STK_ESI				= 0x00000013,
	UNWIND_X86_IND_STK_EDI				= 0x00000014,
	UNWIND_X86_IND_STK_EBX_ESI			= 0x00000015,
	UNWIND_X86_IND_STK_ESI_EDI			= 0x00000016,
	UNWIND_X86_IND_STK_ESI_EDI_EBP      = 0x00000017,
	UNWIND_X86_IND_STK_EBX_ESI_EDI		= 0x00000018,
	UNWIND_X86_IND_STK_EBX_ESI_EDI_EBP  = 0x00000019,
	UNWIND_X86_UNWIND_REQUIRES_DWARF	= 0x0000003F,
};





// x86_64 specific bits
enum {
	UNWIND_X86_64_CASE_MASK							= 0x0000003F,
	UNWIND_X86_64_STACK_SIZE						= 0x000FFFC0,
	UNWIND_X86_64_STACK_ADJUST						= 0x00700000,
										  
	UNWIND_X86_64_UNWIND_INFO_UNSPECIFIED			= 0x00000000,
	UNWIND_X86_64_RBP_FRAME_NO_REGS					= 0x00000001,
	UNWIND_X86_64_RBP_FRAME_RBX						= 0x00000002,
	UNWIND_X86_64_RBP_FRAME_RBX_R12					= 0x00000003,
	UNWIND_X86_64_RBP_FRAME_RBX_R12_R13				= 0x00000004,
	UNWIND_X86_64_RBP_FRAME_RBX_R12_R13_R14			= 0x00000005,
	UNWIND_X86_64_RBP_FRAME_RBX_R12_R13_R14_R15		= 0x00000006,
	
	UNWIND_X86_64_IMM_STK_NO_REGS					= 0x00000010,
	UNWIND_X86_64_IMM_STK_RBX						= 0x00000011,
	UNWIND_X86_64_IMM_STK_RBX_R12					= 0x00000012,
	UNWIND_X86_64_IMM_STK_RBX_RBP					= 0x00000013,
	UNWIND_X86_64_IMM_STK_RBX_R12_R13				= 0x00000014,
	UNWIND_X86_64_IMM_STK_RBX_R12_R13_R14			= 0x00000015,
	UNWIND_X86_64_IMM_STK_RBX_R12_R13_R14_R15		= 0x00000016,
	UNWIND_X86_64_IMM_STK_RBX_RBP_R12_R13_R14_R15	= 0x00000017,
	UNWIND_X86_64_IMM_STK_RBX_RBP_R12				= 0x00000018,
	UNWIND_X86_64_IMM_STK_RBX_RBP_R12_R13			= 0x00000019,
	UNWIND_X86_64_IMM_STK_RBX_RBP_R12_R13_R14		= 0x0000001A,
	
	UNWIND_X86_64_IND_STK_NO_REGS					= 0x00000020,
	UNWIND_X86_64_IND_STK_RBX						= 0x00000021,
	UNWIND_X86_64_IND_STK_RBX_R12					= 0x00000022,
	UNWIND_X86_64_IND_STK_RBX_RBP					= 0x00000023,
	UNWIND_X86_64_IND_STK_RBX_R12_R13				= 0x00000024,
	UNWIND_X86_64_IND_STK_RBX_R12_R13_R14			= 0x00000025,
	UNWIND_X86_64_IND_STK_RBX_R12_R13_R14_R15		= 0x00000026,
	UNWIND_X86_64_IND_STK_RBX_RBP_R12_R13_R14_R15	= 0x00000027,
	UNWIND_X86_64_IND_STK_RBX_RBP_R12				= 0x00000028,
	UNWIND_X86_64_IND_STK_RBX_RBP_R12_R13			= 0x00000029,
	UNWIND_X86_64_IND_STK_RBX_RBP_R12_R13_R14		= 0x0000002A,

	UNWIND_X86_64_UNWIND_REQUIRES_DWARF				= 0x0000003F,
};



#endif

