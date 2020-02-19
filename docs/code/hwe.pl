# snphwe.pl: A Perl implementation of the fast exact Hardy-Weinberg Equilibrium 
# test for SNPs as described in Wigginton, et al. (2005). 
#
# Copyright 2010 Joshua Randall
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author:
#    This software was written Joshua C. Randall <jcrandall@alum.mit.edu>
#    and is a port to Perl of algorithms implemented by others in C and R.
#
# Attribution:
#    This software is based entirely on the C and R implementations of the 
#    algorithms for exact HWE tests as described in Wigginton, et al. (2005), 
#    which were originally written by Jan Wigginton and released into the 
#    public domain.  C, R, and Fortran implementations of these algorithms 
#    are available for download at:
#       http://www.sph.umich.edu/csg/abecasis/Exact/
#
# Citation: 
#    This code implements an exact SNP test of Hardy-Weinberg Equilibrium as described in
#    Wigginton, JE, Cutler, DJ, and Abecasis, GR (2005) A Note on Exact Tests of 
#    Hardy-Weinberg Equilibrium. American Journal of Human Genetics. 76(5): 887 - 893.
#    Please cite this work when using this code.
#
# Usage: 
#    This software is a Perl library, intended to be used within other programs.
#    To use this library directly from the command-line, you can run Perl with a 
#    one-line program such as:
#
#       perl -e 'require "snphwe.pl"; print(snphwe(@ARGV))' 57 14 50
#
#    Where the three numbers at the end are the observed counts of the three 
#    genotypes: first the heterozygote count, then one of the homozygote genotype 
#    counts, and finally the other homozygote genotype count, in that order.  
#
#    The example above, which would be for 57 Aa, 14 aa, and 50 AA, should print 
#    the resulting P-value, which in this case is 0.842279756570793, to the 
#    standard output.
#
# Note:
#    Code for the alternate P-value calculation based on p_hi/p_lo that was 
#    included in the Wigginton, et al. C and R implementations (but was 
#    disabled) has been included here, but has not been tested.  It is 
#    therefore commented out.  If you wish to make use of this code, please 
#    verify it functions as desired.
#
use strict;

sub snphwe {
    my $obs_hets = shift;
    my $obs_hom1 = shift;
    my $obs_hom2 = shift;

    if($obs_hom1 < 0 || $obs_hom2 < 0 || $obs_hets <0) {
	return(-1);
    }

    # rare homozygotes
    my $obs_homr;

    # common homozygotes
    my $obs_homc;
    if($obs_hom1 < $obs_hom2) {
	$obs_homr = $obs_hom1;
	$obs_homc = $obs_hom2;
    } else {
	$obs_homr = $obs_hom2;
	$obs_homc = $obs_hom1;
    }

    # number of rare allele copies
    my $rare_copies = 2 * $obs_homr + $obs_hets;

    # total number of genotypes
    my $genotypes = $obs_homr + $obs_homc + $obs_hets;

    if($genotypes <= 0) {
	return(-1);
    }
    
    # Initialize probability array
    my @het_probs;
    for(my $i=0; $i<=$rare_copies; $i++) {
	$het_probs[$i] = 0.0;
    }

    # start at midpoint
    my $mid = int($rare_copies * (2 * $genotypes - $rare_copies) / (2 * $genotypes));

    # check to ensure that midpoint and rare alleles have same parity
    if(($rare_copies & 1) ^ ($mid & 1)) {
	$mid++;
    }
    
    my $curr_hets = $mid;
    my $curr_homr = ($rare_copies - $mid) / 2;
    my $curr_homc = $genotypes - $curr_hets - $curr_homr;

    $het_probs[$mid] = 1.0;
    my $sum = $het_probs[$mid];
    for($curr_hets = $mid; $curr_hets > 1; $curr_hets -= 2) {
	$het_probs[$curr_hets - 2] = $het_probs[$curr_hets] * $curr_hets * ($curr_hets - 1.0) / (4.0 * ($curr_homr + 1.0) * ($curr_homc + 1.0));
	$sum += $het_probs[$curr_hets - 2];

	# 2 fewer heterozygotes for next iteration -> add one rare, one common homozygote
	$curr_homr++;
	$curr_homc++;
    }

    $curr_hets = $mid;
    $curr_homr = ($rare_copies - $mid) / 2;
    $curr_homc = $genotypes - $curr_hets - $curr_homr;
    for($curr_hets = $mid; $curr_hets <= $rare_copies - 2; $curr_hets += 2) {
	$het_probs[$curr_hets + 2] = $het_probs[$curr_hets] * 4.0 * $curr_homr * $curr_homc / (($curr_hets + 2.0) * ($curr_hets + 1.0));
	$sum += $het_probs[$curr_hets + 2];
	
	# add 2 heterozygotes for next iteration -> subtract one rare, one common homozygote
	$curr_homr--;
	$curr_homc--;
    }

    for(my $i=0; $i<=$rare_copies; $i++) {
	$het_probs[$i] /= $sum;
    }

    # alternate p-value calculation for p_hi/p_lo
#    my $p_hi = $het_probs[$obs_hets];
#    for(my $i=$obs_hets+1; $i<=$rare_copies; $i++) {
#	$p_hi += $het_probs[$i];
#    }
#    
#    my $p_lo = $het_probs[$obs_hets];
#    for(my $i=$obs_hets-1; $i>=0; $i--) {
#	$p_lo += $het_probs[$i];
#    }
#
#    my $p_hi_lo;
#    if($p_hi < $p_lo) {
#	$p_hi_lo = 2 * $p_hi;
#    } else {
#	$p_hi_lo = 2 * $p_lo;
#    }

    # Initialise P-value 
    my $p_hwe = 0.0;

    # P-value calculation for p_hwe
    for(my $i = 0; $i <= $rare_copies; $i++) {
	if($het_probs[$i] > $het_probs[$obs_hets]) {
	    next;
	}
	$p_hwe += $het_probs[$i];
    }
    
    if($p_hwe > 1) {
	$p_hwe = 1.0;
    }

    return($p_hwe);
}

1;

