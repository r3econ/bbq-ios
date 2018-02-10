//
// Copyright (c) 2014 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface UIColor (Extensions)

/// Creates a UIColor from a hex string.
+ (nonnull UIColor *)colorWithHexString:(nonnull NSString *)hexString;

/// Creates a UIColor from a hex string and alpha component.
+ (nonnull UIColor *)colorWithHexString:(nonnull NSString *)hexString alpha:(CGFloat)alpha;

@end
