#
 # rdial.tcl
 #
 # Contents: a "rotated" dial widget or thumbnail "roller" dial
 # Date: Son May 23, 2010
 #
 # Abstract
 #   A mouse drag-able "dial" widget from the side view - visible
 #   is the knurled area - Shift & Ctrl changes the sensitivity 
 #
 # Copyright (c) Gerhard Reithofer, Tech-EDV 2010-05
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # Syntax:
 #   rdial::create w ?-width wid? ?-height hgt?  ?-value floatval?
 #        ?-bg|-background bcol? ?-fg|-foreground fcol? ?-step step?
 #        ?-callback script? ?-scale "degrees"|"radians"|factor?
 #        ?-slow sfact? ?-fast ffact? ?-orient horizontal|vertical?
 #
 # History:
 #  20100526: -scale option added 
 #  20100629: incorrect "rotation direction" in vertical mode repaired
 #
 
 package provide extSummary 0.4
 
 package require Tk 8.5
 
