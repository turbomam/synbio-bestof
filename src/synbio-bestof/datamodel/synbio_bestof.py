# Auto generated from main.yaml by pythongen.py version: 0.9.0
# Generation date: 2022-06-27T13:31:44
# Schema: synbio
#
# id: http://example.com/synbio
# description: A schema for synthetic biology and it's detectability
# license: https://creativecommons.org/publicdomain/zero/1.0/

import dataclasses
import sys
import re
from jsonasobj2 import JsonObj, as_dict
from typing import Optional, List, Union, Dict, ClassVar, Any
from dataclasses import dataclass
from linkml_runtime.linkml_model.meta import EnumDefinition, PermissibleValue, PvFormulaOptions

from linkml_runtime.utils.slot import Slot
from linkml_runtime.utils.metamodelcore import empty_list, empty_dict, bnode
from linkml_runtime.utils.yamlutils import YAMLRoot, extended_str, extended_float, extended_int
from linkml_runtime.utils.dataclass_extensions_376 import dataclasses_init_fn_with_kwargs
from linkml_runtime.utils.formatutils import camelcase, underscore, sfx
from linkml_runtime.utils.enumerations import EnumDefinitionImpl
from rdflib import Namespace, URIRef
from linkml_runtime.utils.curienamespace import CurieNamespace
from linkml_runtime.linkml_model.types import Boolean, Datetime, String
from linkml_runtime.utils.metamodelcore import Bool, XSDDateTime

metamodel_version = "1.7.0"
version = None

# Overwrite dataclasses _init_fn to add **kwargs in __init__
dataclasses._init_fn = dataclasses_init_fn_with_kwargs

# Namespaces
SO = CurieNamespace('SO', 'http://purl.obolibrary.org/obo/SO_')
LINKML = CurieNamespace('linkml', 'https://w3id.org/linkml/')
SYNBIO = CurieNamespace('synbio', 'http://example.com/synbio/')
SYNBIO_MOD = CurieNamespace('synbio_mod', 'http://example.com/synbio/modification/')
SYNBIO_PART = CurieNamespace('synbio_part', 'http://example.com/synbio/part/')
SYNBIO_PERSON = CurieNamespace('synbio_person', 'http://example.com/synbio/person/')
DEFAULT_ = SYNBIO


# Types

# Class references
class PersonPersonId(extended_str):
    pass


class NtseqSeqId(extended_str):
    pass


class ModificationModificationId(extended_str):
    pass


@dataclass
class Organism(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.Organism
    class_class_curie: ClassVar[str] = "synbio:Organism"
    class_name: ClassVar[str] = "Organism"
    class_model_uri: ClassVar[URIRef] = SYNBIO.Organism

    organism_id: Optional[str] = None
    NCBI_id: Optional[str] = None
    details: Optional[str] = None

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        if self.organism_id is not None and not isinstance(self.organism_id, str):
            self.organism_id = str(self.organism_id)

        if self.NCBI_id is not None and not isinstance(self.NCBI_id, str):
            self.NCBI_id = str(self.NCBI_id)

        if self.details is not None and not isinstance(self.details, str):
            self.details = str(self.details)

        super().__post_init__(**kwargs)


@dataclass
class Part(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.Part
    class_class_curie: ClassVar[str] = "synbio:Part"
    class_name: ClassVar[str] = "Part"
    class_model_uri: ClassVar[URIRef] = SYNBIO.Part

    bio_safety_level: str = None
    part_id: str = None
    part_name: str = None
    part_type: str = None
    principal_investigator: str = None
    status: str = None
    summary: str = None
    alias: Optional[str] = None
    creator: Optional[Union[str, PersonPersonId]] = None
    funding_source: Optional[str] = None
    genotype_phenotype: Optional[str] = None
    intellectual_property: Optional[str] = None
    keywords: Optional[str] = None
    notes: Optional[str] = None
    references: Optional[str] = None

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        if self._is_empty(self.bio_safety_level):
            self.MissingRequiredField("bio_safety_level")
        if not isinstance(self.bio_safety_level, str):
            self.bio_safety_level = str(self.bio_safety_level)

        if self._is_empty(self.part_id):
            self.MissingRequiredField("part_id")
        if not isinstance(self.part_id, str):
            self.part_id = str(self.part_id)

        if self._is_empty(self.part_name):
            self.MissingRequiredField("part_name")
        if not isinstance(self.part_name, str):
            self.part_name = str(self.part_name)

        if self._is_empty(self.part_type):
            self.MissingRequiredField("part_type")
        if not isinstance(self.part_type, str):
            self.part_type = str(self.part_type)

        if self._is_empty(self.principal_investigator):
            self.MissingRequiredField("principal_investigator")
        if not isinstance(self.principal_investigator, str):
            self.principal_investigator = str(self.principal_investigator)

        if self._is_empty(self.status):
            self.MissingRequiredField("status")
        if not isinstance(self.status, str):
            self.status = str(self.status)

        if self._is_empty(self.summary):
            self.MissingRequiredField("summary")
        if not isinstance(self.summary, str):
            self.summary = str(self.summary)

        if self.alias is not None and not isinstance(self.alias, str):
            self.alias = str(self.alias)

        if self.creator is not None and not isinstance(self.creator, PersonPersonId):
            self.creator = PersonPersonId(self.creator)

        if self.funding_source is not None and not isinstance(self.funding_source, str):
            self.funding_source = str(self.funding_source)

        if self.genotype_phenotype is not None and not isinstance(self.genotype_phenotype, str):
            self.genotype_phenotype = str(self.genotype_phenotype)

        if self.intellectual_property is not None and not isinstance(self.intellectual_property, str):
            self.intellectual_property = str(self.intellectual_property)

        if self.keywords is not None and not isinstance(self.keywords, str):
            self.keywords = str(self.keywords)

        if self.notes is not None and not isinstance(self.notes, str):
            self.notes = str(self.notes)

        if self.references is not None and not isinstance(self.references, str):
            self.references = str(self.references)

        super().__post_init__(**kwargs)


@dataclass
class Person(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.Person
    class_class_curie: ClassVar[str] = "synbio:Person"
    class_name: ClassVar[str] = "Person"
    class_model_uri: ClassVar[URIRef] = SYNBIO.Person

    person_id: Union[str, PersonPersonId] = None
    first_name: str = None
    person_name: Optional[str] = None
    last_name: Optional[str] = None
    last_login: Optional[Union[str, XSDDateTime]] = None
    is_superuser: Optional[Union[bool, Bool]] = None
    username: Optional[str] = None
    email: Optional[str] = None
    is_staff: Optional[Union[bool, Bool]] = None
    is_active: Optional[Union[bool, Bool]] = None
    date_joined: Optional[Union[str, XSDDateTime]] = None

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        if self._is_empty(self.person_id):
            self.MissingRequiredField("person_id")
        if not isinstance(self.person_id, PersonPersonId):
            self.person_id = PersonPersonId(self.person_id)

        if self._is_empty(self.first_name):
            self.MissingRequiredField("first_name")
        if not isinstance(self.first_name, str):
            self.first_name = str(self.first_name)

        if self.person_name is not None and not isinstance(self.person_name, str):
            self.person_name = str(self.person_name)

        if self.last_name is not None and not isinstance(self.last_name, str):
            self.last_name = str(self.last_name)

        if self.last_login is not None and not isinstance(self.last_login, XSDDateTime):
            self.last_login = XSDDateTime(self.last_login)

        if self.is_superuser is not None and not isinstance(self.is_superuser, Bool):
            self.is_superuser = Bool(self.is_superuser)

        if self.username is not None and not isinstance(self.username, str):
            self.username = str(self.username)

        if self.email is not None and not isinstance(self.email, str):
            self.email = str(self.email)

        if self.is_staff is not None and not isinstance(self.is_staff, Bool):
            self.is_staff = Bool(self.is_staff)

        if self.is_active is not None and not isinstance(self.is_active, Bool):
            self.is_active = Bool(self.is_active)

        if self.date_joined is not None and not isinstance(self.date_joined, XSDDateTime):
            self.date_joined = XSDDateTime(self.date_joined)

        super().__post_init__(**kwargs)


@dataclass
class Ntseq(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.Ntseq
    class_class_curie: ClassVar[str] = "synbio:Ntseq"
    class_name: ClassVar[str] = "Ntseq"
    class_model_uri: ClassVar[URIRef] = SYNBIO.Ntseq

    seq_id: Union[str, NtseqSeqId] = None
    part_id: str = None
    file: str = None
    seq_name: str = None
    seq_type: str = None
    date_added: str = None
    sequence: str = None

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        if self._is_empty(self.seq_id):
            self.MissingRequiredField("seq_id")
        if not isinstance(self.seq_id, NtseqSeqId):
            self.seq_id = NtseqSeqId(self.seq_id)

        if self._is_empty(self.part_id):
            self.MissingRequiredField("part_id")
        if not isinstance(self.part_id, str):
            self.part_id = str(self.part_id)

        if self._is_empty(self.file):
            self.MissingRequiredField("file")
        if not isinstance(self.file, str):
            self.file = str(self.file)

        if self._is_empty(self.seq_name):
            self.MissingRequiredField("seq_name")
        if not isinstance(self.seq_name, str):
            self.seq_name = str(self.seq_name)

        if self._is_empty(self.seq_type):
            self.MissingRequiredField("seq_type")
        if not isinstance(self.seq_type, str):
            self.seq_type = str(self.seq_type)

        if self._is_empty(self.date_added):
            self.MissingRequiredField("date_added")
        if not isinstance(self.date_added, str):
            self.date_added = str(self.date_added)

        if self._is_empty(self.sequence):
            self.MissingRequiredField("sequence")
        if not isinstance(self.sequence, str):
            self.sequence = str(self.sequence)

        super().__post_init__(**kwargs)


@dataclass
class SeqCollection(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.SeqCollection
    class_class_curie: ClassVar[str] = "synbio:SeqCollection"
    class_name: ClassVar[str] = "SeqCollection"
    class_model_uri: ClassVar[URIRef] = SYNBIO.SeqCollection

    sequences: Optional[
        Union[Dict[Union[str, NtseqSeqId], Union[dict, Ntseq]], List[Union[dict, Ntseq]]]] = empty_dict()

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        self._normalize_inlined_as_list(slot_name="sequences", slot_type=Ntseq, key_name="seq_id", keyed=True)

        super().__post_init__(**kwargs)


@dataclass
class Modification(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.Modification
    class_class_curie: ClassVar[str] = "synbio:Modification"
    class_name: ClassVar[str] = "Modification"
    class_model_uri: ClassVar[URIRef] = SYNBIO.Modification

    modification_id: Union[str, ModificationModificationId] = None
    bio_safety_level: str = None
    creator_id: str = None
    element: str = None
    element_id: str = None
    element_id_number: str = None
    mod_alias: str = None
    name: str = None
    principal_investigator: str = None
    status: str = None
    type: str = None
    aa_change: Optional[str] = None
    category: Optional[str] = None
    descriptor: Optional[str] = None
    element_name: Optional[str] = None
    element_species: Optional[str] = None
    email: Optional[str] = None
    modification_type: Optional[str] = None
    notes: Optional[str] = None
    position: Optional[str] = None
    SC_curated_enzyme_name: Optional[str] = None
    SC_curated_gene_name: Optional[str] = None
    SC_curated_protein_name: Optional[str] = None
    SC_curated_uniprot_id: Optional[str] = None
    seq2ids_alias: Optional[str] = None
    seq2ids_all_go: Optional[str] = None
    seq2ids_bitscore: Optional[str] = None
    seq2ids_blast_db: Optional[str] = None
    seq2ids_gene_name_1ry: Optional[str] = None
    seq2ids_gene_names: Optional[str] = None
    seq2ids_organism: Optional[str] = None
    seq2ids_prot_function: Optional[str] = None
    seq2ids_prot_names: Optional[str] = None
    seq2ids_sacc: Optional[str] = None
    size: Optional[str] = None
    subcategory_size: Optional[str] = None
    taxon_id: Optional[str] = None

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        if self._is_empty(self.modification_id):
            self.MissingRequiredField("modification_id")
        if not isinstance(self.modification_id, ModificationModificationId):
            self.modification_id = ModificationModificationId(self.modification_id)

        if self._is_empty(self.bio_safety_level):
            self.MissingRequiredField("bio_safety_level")
        if not isinstance(self.bio_safety_level, str):
            self.bio_safety_level = str(self.bio_safety_level)

        if self._is_empty(self.creator_id):
            self.MissingRequiredField("creator_id")
        if not isinstance(self.creator_id, str):
            self.creator_id = str(self.creator_id)

        if self._is_empty(self.element):
            self.MissingRequiredField("element")
        if not isinstance(self.element, str):
            self.element = str(self.element)

        if self._is_empty(self.element_id):
            self.MissingRequiredField("element_id")
        if not isinstance(self.element_id, str):
            self.element_id = str(self.element_id)

        if self._is_empty(self.element_id_number):
            self.MissingRequiredField("element_id_number")
        if not isinstance(self.element_id_number, str):
            self.element_id_number = str(self.element_id_number)

        if self._is_empty(self.mod_alias):
            self.MissingRequiredField("mod_alias")
        if not isinstance(self.mod_alias, str):
            self.mod_alias = str(self.mod_alias)

        if self._is_empty(self.name):
            self.MissingRequiredField("name")
        if not isinstance(self.name, str):
            self.name = str(self.name)

        if self._is_empty(self.principal_investigator):
            self.MissingRequiredField("principal_investigator")
        if not isinstance(self.principal_investigator, str):
            self.principal_investigator = str(self.principal_investigator)

        if self._is_empty(self.status):
            self.MissingRequiredField("status")
        if not isinstance(self.status, str):
            self.status = str(self.status)

        if self._is_empty(self.type):
            self.MissingRequiredField("type")
        if not isinstance(self.type, str):
            self.type = str(self.type)

        if self.aa_change is not None and not isinstance(self.aa_change, str):
            self.aa_change = str(self.aa_change)

        if self.category is not None and not isinstance(self.category, str):
            self.category = str(self.category)

        if self.descriptor is not None and not isinstance(self.descriptor, str):
            self.descriptor = str(self.descriptor)

        if self.element_name is not None and not isinstance(self.element_name, str):
            self.element_name = str(self.element_name)

        if self.element_species is not None and not isinstance(self.element_species, str):
            self.element_species = str(self.element_species)

        if self.email is not None and not isinstance(self.email, str):
            self.email = str(self.email)

        if self.modification_type is not None and not isinstance(self.modification_type, str):
            self.modification_type = str(self.modification_type)

        if self.notes is not None and not isinstance(self.notes, str):
            self.notes = str(self.notes)

        if self.position is not None and not isinstance(self.position, str):
            self.position = str(self.position)

        if self.SC_curated_enzyme_name is not None and not isinstance(self.SC_curated_enzyme_name, str):
            self.SC_curated_enzyme_name = str(self.SC_curated_enzyme_name)

        if self.SC_curated_gene_name is not None and not isinstance(self.SC_curated_gene_name, str):
            self.SC_curated_gene_name = str(self.SC_curated_gene_name)

        if self.SC_curated_protein_name is not None and not isinstance(self.SC_curated_protein_name, str):
            self.SC_curated_protein_name = str(self.SC_curated_protein_name)

        if self.SC_curated_uniprot_id is not None and not isinstance(self.SC_curated_uniprot_id, str):
            self.SC_curated_uniprot_id = str(self.SC_curated_uniprot_id)

        if self.seq2ids_alias is not None and not isinstance(self.seq2ids_alias, str):
            self.seq2ids_alias = str(self.seq2ids_alias)

        if self.seq2ids_all_go is not None and not isinstance(self.seq2ids_all_go, str):
            self.seq2ids_all_go = str(self.seq2ids_all_go)

        if self.seq2ids_bitscore is not None and not isinstance(self.seq2ids_bitscore, str):
            self.seq2ids_bitscore = str(self.seq2ids_bitscore)

        if self.seq2ids_blast_db is not None and not isinstance(self.seq2ids_blast_db, str):
            self.seq2ids_blast_db = str(self.seq2ids_blast_db)

        if self.seq2ids_gene_name_1ry is not None and not isinstance(self.seq2ids_gene_name_1ry, str):
            self.seq2ids_gene_name_1ry = str(self.seq2ids_gene_name_1ry)

        if self.seq2ids_gene_names is not None and not isinstance(self.seq2ids_gene_names, str):
            self.seq2ids_gene_names = str(self.seq2ids_gene_names)

        if self.seq2ids_organism is not None and not isinstance(self.seq2ids_organism, str):
            self.seq2ids_organism = str(self.seq2ids_organism)

        if self.seq2ids_prot_function is not None and not isinstance(self.seq2ids_prot_function, str):
            self.seq2ids_prot_function = str(self.seq2ids_prot_function)

        if self.seq2ids_prot_names is not None and not isinstance(self.seq2ids_prot_names, str):
            self.seq2ids_prot_names = str(self.seq2ids_prot_names)

        if self.seq2ids_sacc is not None and not isinstance(self.seq2ids_sacc, str):
            self.seq2ids_sacc = str(self.seq2ids_sacc)

        if self.size is not None and not isinstance(self.size, str):
            self.size = str(self.size)

        if self.subcategory_size is not None and not isinstance(self.subcategory_size, str):
            self.subcategory_size = str(self.subcategory_size)

        if self.taxon_id is not None and not isinstance(self.taxon_id, str):
            self.taxon_id = str(self.taxon_id)

        super().__post_init__(**kwargs)


@dataclass
class ModCollection(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.ModCollection
    class_class_curie: ClassVar[str] = "synbio:ModCollection"
    class_name: ClassVar[str] = "ModCollection"
    class_model_uri: ClassVar[URIRef] = SYNBIO.ModCollection

    modifications: Optional[Union[Dict[Union[str, ModificationModificationId], Union[dict, Modification]], List[
        Union[dict, Modification]]]] = empty_dict()

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        self._normalize_inlined_as_list(slot_name="modifications", slot_type=Modification, key_name="modification_id",
                                        keyed=True)

        super().__post_init__(**kwargs)


@dataclass
class OmniCollection(YAMLRoot):
    _inherited_slots: ClassVar[List[str]] = []

    class_class_uri: ClassVar[URIRef] = SYNBIO.OmniCollection
    class_class_curie: ClassVar[str] = "synbio:OmniCollection"
    class_name: ClassVar[str] = "OmniCollection"
    class_model_uri: ClassVar[URIRef] = SYNBIO.OmniCollection

    sequences: Optional[
        Union[Dict[Union[str, NtseqSeqId], Union[dict, Ntseq]], List[Union[dict, Ntseq]]]] = empty_dict()
    modifications: Optional[Union[Dict[Union[str, ModificationModificationId], Union[dict, Modification]], List[
        Union[dict, Modification]]]] = empty_dict()

    def __post_init__(self, *_: List[str], **kwargs: Dict[str, Any]):
        self._normalize_inlined_as_list(slot_name="sequences", slot_type=Ntseq, key_name="seq_id", keyed=True)

        self._normalize_inlined_as_list(slot_name="modifications", slot_type=Modification, key_name="modification_id",
                                        keyed=True)

        super().__post_init__(**kwargs)


# Enumerations
class SeqTypeEnum(EnumDefinitionImpl):
    insertion = PermissibleValue(text="insertion",
                                 meaning=SO["0000667"])
    sequence = PermissibleValue(text="sequence",
                                meaning=SO["0000001"])
    deletion = PermissibleValue(text="deletion",
                                meaning=SO["0000159"])
    flank2 = PermissibleValue(text="flank2")
    flank1 = PermissibleValue(text="flank1")

    _defn = EnumDefinition(
        name="SeqTypeEnum",
    )


class ModCatEnum(EnumDefinitionImpl):
    biosynthetic = PermissibleValue(text="biosynthetic")
    compound = PermissibleValue(text="compound")
    promoter = PermissibleValue(text="promoter")
    terminator = PermissibleValue(text="terminator")
    GOI = PermissibleValue(text="GOI")

    _defn = EnumDefinition(
        name="ModCatEnum",
    )

    @classmethod
    def _addvals(cls):
        setattr(cls, "origin/structural",
                PermissibleValue(text="origin/structural"))
        setattr(cls, "toxin/virulence",
                PermissibleValue(text="toxin/virulence"))
        setattr(cls, "control element",
                PermissibleValue(text="control element"))
        setattr(cls, "antibiotic resistance",
                PermissibleValue(text="antibiotic resistance"))
        setattr(cls, "fluorescent/epitope",
                PermissibleValue(text="fluorescent/epitope"))


class ModTypeEnum(EnumDefinitionImpl):
    Plasmid = PermissibleValue(text="Plasmid",
                               meaning=SO["0000155"])
    deletion = PermissibleValue(text="deletion",
                                meaning=SO["0000159"])
    insertion = PermissibleValue(text="insertion",
                                 meaning=SO["0000667"])
    frameshift = PermissibleValue(text="frameshift",
                                  meaning=SO["0000865"])
    CDSpartial = PermissibleValue(text="CDSpartial",
                                  meaning=SO["0001384"])
    subtitutions = PermissibleValue(text="subtitutions",
                                    meaning=SO["1000002"])
    transition = PermissibleValue(text="transition",
                                  meaning=SO["1000009"])
    inversion = PermissibleValue(text="inversion",
                                 meaning=SO["1000036"])
    reassortment = PermissibleValue(text="reassortment")

    _defn = EnumDefinition(
        name="ModTypeEnum",
    )

    @classmethod
    def _addvals(cls):
        setattr(cls, "amber.stop.codon",
                PermissibleValue(text="amber.stop.codon",
                                 meaning=SO["0002333"]))
        setattr(cls, "ochre.stop.codon",
                PermissibleValue(text="ochre.stop.codon",
                                 meaning=SO["0002334"]))
        setattr(cls, "substitution.transition",
                PermissibleValue(text="substitution.transition",
                                 meaning=SO["1000009"]))
        setattr(cls, "substitution.transversion",
                PermissibleValue(text="substitution.transversion",
                                 meaning=SO["1000017"]))
        setattr(cls, "plasmid.element",
                PermissibleValue(text="plasmid.element"))
        setattr(cls, "compound.insertion",
                PermissibleValue(text="compound.insertion"))
        setattr(cls, "compound.deletion",
                PermissibleValue(text="compound.deletion"))
        setattr(cls, "insertion.site",
                PermissibleValue(text="insertion.site"))
        setattr(cls, "fluorescent/epitope",
                PermissibleValue(text="fluorescent/epitope"))
        setattr(cls, "transition,plasmid.element",
                PermissibleValue(text="transition,plasmid.element"))
        setattr(cls, "in-frame.deletion",
                PermissibleValue(text="in-frame.deletion"))
        setattr(cls, "plasmid element",
                PermissibleValue(text="plasmid element"))
        setattr(cls, "chrXIII-chrII",
                PermissibleValue(text="chrXIII-chrII"))
        setattr(cls, "transition.plasmid.element",
                PermissibleValue(text="transition.plasmid.element"))


class ModDescriptorEnum(EnumDefinitionImpl):
    CDSpartial = PermissibleValue(text="CDSpartial")
    CDS = PermissibleValue(text="CDS")
    terminator = PermissibleValue(text="terminator")
    scar = PermissibleValue(text="scar")
    promoter = PermissibleValue(text="promoter")
    gene = PermissibleValue(text="gene")
    fragment = PermissibleValue(text="fragment")
    epitope = PermissibleValue(text="epitope")

    _defn = EnumDefinition(
        name="ModDescriptorEnum",
    )

    @classmethod
    def _addvals(cls):
        setattr(cls, "CDSpartial-5prime",
                PermissibleValue(text="CDSpartial-5prime"))
        setattr(cls, "CDSpartial-3prime",
                PermissibleValue(text="CDSpartial-3prime"))
        setattr(cls, "1bpG707A",
                PermissibleValue(text="1bpG707A"))
        setattr(cls, "ribosomal.binding.site",
                PermissibleValue(text="ribosomal.binding.site"))


# Slots
class slots:
    pass


slots.aa_change = Slot(uri=SYNBIO.aa_change, name="aa_change", curie=SYNBIO.curie('aa_change'),
                       model_uri=SYNBIO.aa_change, domain=None, range=Optional[str])

slots.alias = Slot(uri=SYNBIO.alias, name="alias", curie=SYNBIO.curie('alias'),
                   model_uri=SYNBIO.alias, domain=None, range=Optional[str])

slots.bio_safety_level = Slot(uri=SYNBIO.bio_safety_level, name="bio_safety_level",
                              curie=SYNBIO.curie('bio_safety_level'),
                              model_uri=SYNBIO.bio_safety_level, domain=None, range=str)

slots.category = Slot(uri=SYNBIO.category, name="category", curie=SYNBIO.curie('category'),
                      model_uri=SYNBIO.category, domain=None, range=Optional[str])

slots.creator = Slot(uri=SYNBIO.creator, name="creator", curie=SYNBIO.curie('creator'),
                     model_uri=SYNBIO.creator, domain=None, range=Optional[Union[str, PersonPersonId]])

slots.creator_id = Slot(uri=SYNBIO.creator_id, name="creator_id", curie=SYNBIO.curie('creator_id'),
                        model_uri=SYNBIO.creator_id, domain=None, range=str)

slots.date_added = Slot(uri=SYNBIO.date_added, name="date_added", curie=SYNBIO.curie('date_added'),
                        model_uri=SYNBIO.date_added, domain=None, range=str)

slots.date_joined = Slot(uri=SYNBIO.date_joined, name="date_joined", curie=SYNBIO.curie('date_joined'),
                         model_uri=SYNBIO.date_joined, domain=None, range=Optional[Union[str, XSDDateTime]])

slots.descriptor = Slot(uri=SYNBIO.descriptor, name="descriptor", curie=SYNBIO.curie('descriptor'),
                        model_uri=SYNBIO.descriptor, domain=None, range=Optional[str])

slots.details = Slot(uri=SYNBIO.details, name="details", curie=SYNBIO.curie('details'),
                     model_uri=SYNBIO.details, domain=None, range=Optional[str])

slots.element = Slot(uri=SYNBIO.element, name="element", curie=SYNBIO.curie('element'),
                     model_uri=SYNBIO.element, domain=None, range=str)

slots.element_id = Slot(uri=SYNBIO.element_id, name="element_id", curie=SYNBIO.curie('element_id'),
                        model_uri=SYNBIO.element_id, domain=None, range=str)

slots.element_id_number = Slot(uri=SYNBIO.element_id_number, name="element_id_number",
                               curie=SYNBIO.curie('element_id_number'),
                               model_uri=SYNBIO.element_id_number, domain=None, range=str)

slots.element_name = Slot(uri=SYNBIO.element_name, name="element_name", curie=SYNBIO.curie('element_name'),
                          model_uri=SYNBIO.element_name, domain=None, range=Optional[str])

slots.element_species = Slot(uri=SYNBIO.element_species, name="element_species", curie=SYNBIO.curie('element_species'),
                             model_uri=SYNBIO.element_species, domain=None, range=Optional[str])

slots.email = Slot(uri=SYNBIO.email, name="email", curie=SYNBIO.curie('email'),
                   model_uri=SYNBIO.email, domain=None, range=Optional[str])

slots.file = Slot(uri=SYNBIO.file, name="file", curie=SYNBIO.curie('file'),
                  model_uri=SYNBIO.file, domain=None, range=str)

slots.first_name = Slot(uri=SYNBIO.first_name, name="first_name", curie=SYNBIO.curie('first_name'),
                        model_uri=SYNBIO.first_name, domain=None, range=str)

slots.funding_source = Slot(uri=SYNBIO.funding_source, name="funding_source", curie=SYNBIO.curie('funding_source'),
                            model_uri=SYNBIO.funding_source, domain=None, range=Optional[str])

slots.genotype_phenotype = Slot(uri=SYNBIO.genotype_phenotype, name="genotype_phenotype",
                                curie=SYNBIO.curie('genotype_phenotype'),
                                model_uri=SYNBIO.genotype_phenotype, domain=None, range=Optional[str])

slots.host_species_id = Slot(uri=SYNBIO.host_species_id, name="host_species_id", curie=SYNBIO.curie('host_species_id'),
                             model_uri=SYNBIO.host_species_id, domain=None, range=Optional[str])

slots.id = Slot(uri=SYNBIO.id, name="id", curie=SYNBIO.curie('id'),
                model_uri=SYNBIO.id, domain=None, range=Optional[str])

slots.intellectual_property = Slot(uri=SYNBIO.intellectual_property, name="intellectual_property",
                                   curie=SYNBIO.curie('intellectual_property'),
                                   model_uri=SYNBIO.intellectual_property, domain=None, range=Optional[str])

slots.is_active = Slot(uri=SYNBIO.is_active, name="is_active", curie=SYNBIO.curie('is_active'),
                       model_uri=SYNBIO.is_active, domain=None, range=Optional[Union[bool, Bool]])

slots.is_staff = Slot(uri=SYNBIO.is_staff, name="is_staff", curie=SYNBIO.curie('is_staff'),
                      model_uri=SYNBIO.is_staff, domain=None, range=Optional[Union[bool, Bool]])

slots.is_superuser = Slot(uri=SYNBIO.is_superuser, name="is_superuser", curie=SYNBIO.curie('is_superuser'),
                          model_uri=SYNBIO.is_superuser, domain=None, range=Optional[Union[bool, Bool]])

slots.keywords = Slot(uri=SYNBIO.keywords, name="keywords", curie=SYNBIO.curie('keywords'),
                      model_uri=SYNBIO.keywords, domain=None, range=Optional[str])

slots.last_login = Slot(uri=SYNBIO.last_login, name="last_login", curie=SYNBIO.curie('last_login'),
                        model_uri=SYNBIO.last_login, domain=None, range=Optional[Union[str, XSDDateTime]])

slots.last_name = Slot(uri=SYNBIO.last_name, name="last_name", curie=SYNBIO.curie('last_name'),
                       model_uri=SYNBIO.last_name, domain=None, range=Optional[str])

slots.middle_init_or_name = Slot(uri=SYNBIO.middle_init_or_name, name="middle_init_or_name",
                                 curie=SYNBIO.curie('middle_init_or_name'),
                                 model_uri=SYNBIO.middle_init_or_name, domain=None, range=Optional[str])

slots.mod_alias = Slot(uri=SYNBIO.mod_alias, name="mod_alias", curie=SYNBIO.curie('mod_alias'),
                       model_uri=SYNBIO.mod_alias, domain=None, range=str)

slots.modification_id = Slot(uri=SYNBIO.modification_id, name="modification_id", curie=SYNBIO.curie('modification_id'),
                             model_uri=SYNBIO.modification_id, domain=None, range=URIRef)

slots.modification_type = Slot(uri=SYNBIO.modification_type, name="modification_type",
                               curie=SYNBIO.curie('modification_type'),
                               model_uri=SYNBIO.modification_type, domain=None, range=Optional[str])

slots.modifications = Slot(uri=SYNBIO.modifications, name="modifications", curie=SYNBIO.curie('modifications'),
                           model_uri=SYNBIO.modifications, domain=None, range=Optional[Union[
        Dict[Union[str, ModificationModificationId], Union[dict, Modification]], List[Union[dict, Modification]]]])

slots.name = Slot(uri=SYNBIO.name, name="name", curie=SYNBIO.curie('name'),
                  model_uri=SYNBIO.name, domain=None, range=str)

slots.NCBI_id = Slot(uri=SYNBIO.NCBI_id, name="NCBI_id", curie=SYNBIO.curie('NCBI_id'),
                     model_uri=SYNBIO.NCBI_id, domain=None, range=Optional[str])

slots.notes = Slot(uri=SYNBIO.notes, name="notes", curie=SYNBIO.curie('notes'),
                   model_uri=SYNBIO.notes, domain=None, range=Optional[str])

slots.organism_id = Slot(uri=SYNBIO.organism_id, name="organism_id", curie=SYNBIO.curie('organism_id'),
                         model_uri=SYNBIO.organism_id, domain=None, range=Optional[str])

slots.part_id = Slot(uri=SYNBIO.part_id, name="part_id", curie=SYNBIO.curie('part_id'),
                     model_uri=SYNBIO.part_id, domain=None, range=str)

slots.part_name = Slot(uri=SYNBIO.part_name, name="part_name", curie=SYNBIO.curie('part_name'),
                       model_uri=SYNBIO.part_name, domain=None, range=str)

slots.part_type = Slot(uri=SYNBIO.part_type, name="part_type", curie=SYNBIO.curie('part_type'),
                       model_uri=SYNBIO.part_type, domain=None, range=str)

slots.parts_ptr_id = Slot(uri=SYNBIO.parts_ptr_id, name="parts_ptr_id", curie=SYNBIO.curie('parts_ptr_id'),
                          model_uri=SYNBIO.parts_ptr_id, domain=None, range=str)

slots.person_id = Slot(uri=SYNBIO.person_id, name="person_id", curie=SYNBIO.curie('person_id'),
                       model_uri=SYNBIO.person_id, domain=None, range=URIRef)

slots.person_name = Slot(uri=SYNBIO.person_name, name="person_name", curie=SYNBIO.curie('person_name'),
                         model_uri=SYNBIO.person_name, domain=None, range=Optional[str])

slots.position = Slot(uri=SYNBIO.position, name="position", curie=SYNBIO.curie('position'),
                      model_uri=SYNBIO.position, domain=None, range=Optional[str])

slots.principal_investigator = Slot(uri=SYNBIO.principal_investigator, name="principal_investigator",
                                    curie=SYNBIO.curie('principal_investigator'),
                                    model_uri=SYNBIO.principal_investigator, domain=None, range=str)

slots.references = Slot(uri=SYNBIO.references, name="references", curie=SYNBIO.curie('references'),
                        model_uri=SYNBIO.references, domain=None, range=Optional[str])

slots.SC_curated_enzyme_name = Slot(uri=SYNBIO.SC_curated_enzyme_name, name="SC_curated_enzyme_name",
                                    curie=SYNBIO.curie('SC_curated_enzyme_name'),
                                    model_uri=SYNBIO.SC_curated_enzyme_name, domain=None, range=Optional[str])

slots.SC_curated_gene_name = Slot(uri=SYNBIO.SC_curated_gene_name, name="SC_curated_gene_name",
                                  curie=SYNBIO.curie('SC_curated_gene_name'),
                                  model_uri=SYNBIO.SC_curated_gene_name, domain=None, range=Optional[str])

slots.SC_curated_protein_name = Slot(uri=SYNBIO.SC_curated_protein_name, name="SC_curated_protein_name",
                                     curie=SYNBIO.curie('SC_curated_protein_name'),
                                     model_uri=SYNBIO.SC_curated_protein_name, domain=None, range=Optional[str])

slots.SC_curated_uniprot_id = Slot(uri=SYNBIO.SC_curated_uniprot_id, name="SC_curated_uniprot_id",
                                   curie=SYNBIO.curie('SC_curated_uniprot_id'),
                                   model_uri=SYNBIO.SC_curated_uniprot_id, domain=None, range=Optional[str])

slots.seq_id = Slot(uri=SYNBIO.seq_id, name="seq_id", curie=SYNBIO.curie('seq_id'),
                    model_uri=SYNBIO.seq_id, domain=None, range=URIRef)

slots.seq_name = Slot(uri=SYNBIO.seq_name, name="seq_name", curie=SYNBIO.curie('seq_name'),
                      model_uri=SYNBIO.seq_name, domain=None, range=str)

slots.seq_type = Slot(uri=SYNBIO.seq_type, name="seq_type", curie=SYNBIO.curie('seq_type'),
                      model_uri=SYNBIO.seq_type, domain=None, range=str)

slots.seq2ids_alias = Slot(uri=SYNBIO.seq2ids_alias, name="seq2ids_alias", curie=SYNBIO.curie('seq2ids_alias'),
                           model_uri=SYNBIO.seq2ids_alias, domain=None, range=Optional[str])

slots.seq2ids_all_go = Slot(uri=SYNBIO.seq2ids_all_go, name="seq2ids_all_go", curie=SYNBIO.curie('seq2ids_all_go'),
                            model_uri=SYNBIO.seq2ids_all_go, domain=None, range=Optional[str])

slots.seq2ids_bitscore = Slot(uri=SYNBIO.seq2ids_bitscore, name="seq2ids_bitscore",
                              curie=SYNBIO.curie('seq2ids_bitscore'),
                              model_uri=SYNBIO.seq2ids_bitscore, domain=None, range=Optional[str])

slots.seq2ids_blast_db = Slot(uri=SYNBIO.seq2ids_blast_db, name="seq2ids_blast_db",
                              curie=SYNBIO.curie('seq2ids_blast_db'),
                              model_uri=SYNBIO.seq2ids_blast_db, domain=None, range=Optional[str])

slots.seq2ids_gene_name_1ry = Slot(uri=SYNBIO.seq2ids_gene_name_1ry, name="seq2ids_gene_name_1ry",
                                   curie=SYNBIO.curie('seq2ids_gene_name_1ry'),
                                   model_uri=SYNBIO.seq2ids_gene_name_1ry, domain=None, range=Optional[str])

slots.seq2ids_gene_names = Slot(uri=SYNBIO.seq2ids_gene_names, name="seq2ids_gene_names",
                                curie=SYNBIO.curie('seq2ids_gene_names'),
                                model_uri=SYNBIO.seq2ids_gene_names, domain=None, range=Optional[str])

slots.seq2ids_organism = Slot(uri=SYNBIO.seq2ids_organism, name="seq2ids_organism",
                              curie=SYNBIO.curie('seq2ids_organism'),
                              model_uri=SYNBIO.seq2ids_organism, domain=None, range=Optional[str])

slots.seq2ids_prot_function = Slot(uri=SYNBIO.seq2ids_prot_function, name="seq2ids_prot_function",
                                   curie=SYNBIO.curie('seq2ids_prot_function'),
                                   model_uri=SYNBIO.seq2ids_prot_function, domain=None, range=Optional[str])

slots.seq2ids_prot_names = Slot(uri=SYNBIO.seq2ids_prot_names, name="seq2ids_prot_names",
                                curie=SYNBIO.curie('seq2ids_prot_names'),
                                model_uri=SYNBIO.seq2ids_prot_names, domain=None, range=Optional[str])

slots.seq2ids_sacc = Slot(uri=SYNBIO.seq2ids_sacc, name="seq2ids_sacc", curie=SYNBIO.curie('seq2ids_sacc'),
                          model_uri=SYNBIO.seq2ids_sacc, domain=None, range=Optional[str])

slots.sequence = Slot(uri=SYNBIO.sequence, name="sequence", curie=SYNBIO.curie('sequence'),
                      model_uri=SYNBIO.sequence, domain=None, range=str,
                      pattern=re.compile(r'^[ACGTacgt]+$'))

slots.sequences = Slot(uri=SYNBIO.sequences, name="sequences", curie=SYNBIO.curie('sequences'),
                       model_uri=SYNBIO.sequences, domain=None, range=Optional[
        Union[Dict[Union[str, NtseqSeqId], Union[dict, Ntseq]], List[Union[dict, Ntseq]]]])

slots.size = Slot(uri=SYNBIO.size, name="size", curie=SYNBIO.curie('size'),
                  model_uri=SYNBIO.size, domain=None, range=Optional[str])

slots.status = Slot(uri=SYNBIO.status, name="status", curie=SYNBIO.curie('status'),
                    model_uri=SYNBIO.status, domain=None, range=str)

slots.subcategory_size = Slot(uri=SYNBIO.subcategory_size, name="subcategory_size",
                              curie=SYNBIO.curie('subcategory_size'),
                              model_uri=SYNBIO.subcategory_size, domain=None, range=Optional[str])

slots.summary = Slot(uri=SYNBIO.summary, name="summary", curie=SYNBIO.curie('summary'),
                     model_uri=SYNBIO.summary, domain=None, range=str)

slots.taxon_id = Slot(uri=SYNBIO.taxon_id, name="taxon_id", curie=SYNBIO.curie('taxon_id'),
                      model_uri=SYNBIO.taxon_id, domain=None, range=Optional[str])

slots.type = Slot(uri=SYNBIO.type, name="type", curie=SYNBIO.curie('type'),
                  model_uri=SYNBIO.type, domain=None, range=str)

slots.username = Slot(uri=SYNBIO.username, name="username", curie=SYNBIO.curie('username'),
                      model_uri=SYNBIO.username, domain=None, range=Optional[str])
