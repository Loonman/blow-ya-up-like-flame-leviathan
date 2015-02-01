//
//  MatrixMath.swift
//  Math
//
//  Created by David Skrundz on 2014-06-11.
//  Copyright (c) 2014 David Skrundz. All rights reserved.
//

import Foundation

/// A Matrix Class That Supports All Operations
public class Matrix {
	/// Size of the Matrix
	public let rows: Int
	public let columns: Int
	
	/// The raw values
	private var values: [Double]
	
	// MARK: Initializers
	
	/// Create a new empty (all 0s) Matrix
	public init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
		self.values = [Double](count: rows * columns, repeatedValue: 0.0)
	}
	
	// MARK: Indexing
	
	private func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
	
	/// Returns the value at the set row and column
	public subscript(row: Int, column: Int) -> Double {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return values[(row * columns) + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			values[(row * columns) + column] = newValue
		}
	}
	
	/// Used when the column can only be 0. For Matrix Vectors Only!
	public subscript(row: Int) -> Double {
		get {
			assert(self.columns == 1, "Bad Access: Columns != 1")
			return values[row]
		}
		set {
			assert(self.columns == 1, "Bad Access: Columns != 1")
			values[row] = newValue
		}
	}
	
	// MARK: Pretty Printing
	
	/// Returns a visual representation of the Matrix for printing
	public func description() -> String {
		var str = ""
		for y in 0..<rows {
			for x in 0..<columns {
				str += "\(self[y, x])\t"
			}
			str += "\n"
		}
		return str
	}
	
	// MARK: Dimension Checking
	
	private func isCompatibleForPlusMinusWithMatrix(other: Matrix) -> Bool {
		return (self.rows == other.rows && self.columns == other.columns)
	}
	
	private func isCompatibleForMultiplicationWithMatrixFromLeft(right: Matrix) -> Bool {
		return self.columns == right.rows
	}
	
	/// Returns true if rows == columns
	public func isSquare() -> Bool {
		return self.rows == self.columns
	}
	
	// MARK: Duplicate
	
	/// Returns a duplicate matrix
	public func copy() -> Matrix {
		var matrix = Matrix(rows: self.rows, columns: self.columns)
		for i in 0..<self.values.count {
			matrix.values[i] = self.values[i]
		}
		return matrix
	}
	
	// MARK: Row Operations
	
	/// Swaps two rows of the Matrix
	public func swapRows(row1: Int, row2: Int) {
		for jj in 0..<self.columns {
			swap(&self[row1, jj], &self[row2, jj])
		}
	}
	
	/// Add the values of one row to another
	public func addRow(row: Int, toRow: Int, multiplier: Double) {
		for jj in 0..<self.columns {
			self[toRow, jj] += self[row, jj] * multiplier
		}
	}
	
	/// Multiply the values of a row by a number
	public func multiplyRow(row: Int, multiplier: Double) {
		for jj in 0..<self.columns {
			self[row, jj] *= multiplier
		}
	}
	
	// MARK: Calculations
	
	/// Calculate the transpose of the Matrix. (Returns a new Matrix)
	public func transpose() -> Matrix {
		assert(self.isSquare(), "Cannot to transpose non-square Matrix")
		var matrix = Matrix(rows: self.rows, columns: self.columns)
		for i in 0..<self.rows {
			for j in 0..<self.columns {
				matrix[i, j] = self[j, i]
			}
		}
		return matrix
	}
	
	/// Performs Row Reduction on the Matrix. Returns the 'value' of the total operations executed
	public func rref() -> Double {
		var i = 0
		var j = 0
		var operations = 1.0
		let tolerance = 0.0
		while i < self.rows && j < self.columns {
			// Find the largest element in the column
			var largestValue = 0.0
			var valueIndex = 0
			for ii in i..<self.rows {
				if (self[ii, j].absolute > largestValue) {
					largestValue = self[ii, j].absolute
					valueIndex = ii
				}
			}
			// Zero out empty column
			if largestValue <= tolerance {
				for ii in i..<self.rows {
					self[ii, j] = 0
				}
				j++
			} else {
				if (i != valueIndex) {
					self.swapRows(i, row2: valueIndex)
					operations *= -1
				}
				// Divide the pivot row by the pivot element
				operations *= self[i, j] // Add to operations for determinant calculation
				for jj in reverse(j..<self.columns) {
					self[i, jj] = self[i, jj] / self[i, j]
				}
				// Subtract multiples of the pivot row from all the other rows
				for ii in 0..<self.rows {
					if (ii == i) { continue } // Skip pivot row
					for jj in reverse(j..<self.columns) {
						self[ii, jj] = self[ii, jj] - (self[ii, j] * self[i, jj])
					}
				}
				i++
				j++
			}
		}
		return operations
	}
	
	/// Returns the determinant of the Matrix
	public func determinant() -> Double {
		assert(self.rows == self.columns, "The Matrix MUST be square to calculate the determinant")
		var matrix = self.copy()
		let operations = matrix.rref()
		for i in 0..<matrix.rows {
			if matrix[i, i] == 0.0 {
				return 0.0
			}
		}
		return operations
	}
	
	/// Returns the inverse of the Matrix
	func inverse() -> Matrix? {
		assert(self.rows == self.columns, "The Matrix MUST be square to calculate the inverse")
		var wideMatrix = Matrix(rows: self.rows, columns: self.columns * 2)
		for i in 0..<self.rows {
			for j in 0..<self.columns {
				wideMatrix[i, j] = self[i, j]
			}
			for j in self.columns..<wideMatrix.columns {
				if j - self.rows == i {
					wideMatrix[i, j] = 1
				} else {
					wideMatrix[i, j] = 0
				}
			}
		}
		wideMatrix = wideMatrix.copy()
		wideMatrix.rref()
		var matrix = Matrix(rows: self.rows, columns: self.columns)
		for i in 0..<self.rows {
			for j in 0..<self.columns {
				matrix[i, j] = wideMatrix[i, j + self.columns]
				// Also verify that we have a proper inverse
				var value = 0.0
				if i == j {
					value = 1.0
				}
				if wideMatrix[i, j] != value {
					return nil
				}
			}
		}
		return matrix
	}
}

/// Provides Some Often Used Matrices
public extension Matrix {
	/// The Identity Matrix
	public class func Identity(width: Int) -> Matrix {
		var newMatrix = Matrix(rows: width, columns: width)
		for i in 0..<width {
			newMatrix[i, i] = 1.0
		}
		return newMatrix
	}
	
	/// A Rotation Matrix On The X Axis
	public class func RotationMatrixX(theta: Double) -> Matrix {
		var matrix = Matrix(rows: 3, columns: 3)
		matrix[0, 0] = 1.0
		matrix[1, 1] = cos(theta)
		matrix[1, 2] = -sin(theta)
		matrix[2, 1] = sin(theta)
		matrix[2, 2] = cos(theta)
		return matrix
	}
	
	/// A Rotation Matrix On The Y Axis
	public class func RotationMatrixY(theta: Double) -> Matrix {
		var matrix = Matrix(rows: 3, columns: 3)
		matrix[1, 1] = 1.0
		matrix[0, 0] = cos(theta)
		matrix[0, 2] = sin(theta)
		matrix[2, 0] = -sin(theta)
		matrix[2, 2] = cos(theta)
		return matrix
	}
	
	/// A Rotation Matrix On The Z Axis
	public class func RotationMatrixZ(theta: Double) -> Matrix {
		var matrix = Matrix(rows: 3, columns: 3)
		matrix[2, 2] = 1.0
		matrix[0, 0] = cos(theta)
		matrix[0, 1] = -sin(theta)
		matrix[1, 0] = sin(theta)
		matrix[1, 1] = cos(theta)
		return matrix
	}
}